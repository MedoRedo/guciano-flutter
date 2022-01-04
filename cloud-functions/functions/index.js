const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const db = admin.firestore();

exports.createOrder = functions.https.onRequest(async (request, response) => {
  // Verify request method call.
  if (request.method != 'POST') {
    return response.status(500).json({
      error_code: 'invalid_http_call',
      message: 'Not allowed.'
    });
  }

  // Get request query.
  const body = request.body;
  functions.logger.debug(`Request body: ${JSON.stringify(body)}.`);

  const userId = body.userId;
  const order = body.order;

  // Initialize user reference.
  const userRef = db.collection('users').doc(userId);

  // Verify user exists.
  const userDoc = await userRef.get().catch(function (error) {
    functions.logger.error(`Failed to verify user ${userId}.`, error);
    return response.status(500).json({
      error_code: 'internal_error',
      message: 'An internal server error occurred.'
    });
  });

  if (!userDoc.exists) {
    return response.status(500).json({
      error_code: 'invalid_user',
      message: 'User does not exist.'
    });
  }

  // Initialize order number.
  var orderNumber = userDoc.data()['last_order_number'];

  if (orderNumber == null) {
    orderNumber = 1;
  } else {
    orderNumber += 1;
  }

  // Calculate order total price.
  var totalPrice = 0;
  order.items.forEach(function (item) {
    totalPrice += item.price;
  });

  // Initialize order reference.
  const orderRef = userRef.collection('orders').doc();

  // Create order.
  await orderRef.create({
    order_number: orderNumber,
    order_status: 'in_progress',
    delivery_option: order.delivery_option,
    payment_option: order.payment_option,
    items_count: order.items.length,
    total_price: totalPrice,
    timestamp: admin.firestore.FieldValue.serverTimestamp()
  }).catch(function (error) {
    functions.logger.error(`Failed to create order ${orderNumber}.`, error);
    return response.status(500).json({
      error_code: 'internal_error',
      message: 'An internal server error occurred.'
    });
  });

  // Initialize order items reference.
  const orderItemsRef = orderRef.collection('items');

  // Create order items.
  order.items.forEach(async function (item) {
    await orderItemsRef.doc(item.id).create({
      name: item.name,
      image: item.image,
      count: item.count,
      price: item.price
    }).catch(function (error) {
      functions.logger.error(`Failed to create order item ${item.name}.`, error);
      return response.status(500).json({
        error_code: 'internal_error',
        message: 'An internal server error occurred.'
      });
    });
  });

  // Update last order number.
  await userRef.update({
    last_order_number: orderNumber
  });

  const tokens = userDoc.data().tokens;

  // Update order status after some time.
  if (order.delivery_option == 'kiosk') {
    setTimeout(async function () {
      await orderRef.update({
        order_status: 'done'
      }).then(value => {
        var payload = {notification: {title: 'Ready', body: 'Your order is ready'}}
        admin.messaging().sendToDevice(tokens, payload)
      });
    }, 10000);
  } else if (order.delivery_option == 'dorm') {
    setTimeout(async function () {
      await orderRef.update({
        order_status: 'delivering'
      }).then(value => {
        var payload = {notification: {title: 'Ready', body: 'Your order is ready and on its way now'}}
        admin.messaging().sendToDevice(tokens, payload)
      });

      setTimeout(async function () {
        await orderRef.update({
          order_status: 'done'
        }).then(value => {
          var payload = {notification: {title: 'Enjoy your meal', body: 'Your order has been successfully delivered'}}
          admin.messaging().sendToDevice(tokens, payload)
          });
      }, 10000);
    }, 10000);
  }

  // Return success.
  return response.status(200).json({
    message: 'Created order successfully.'
  });
});
