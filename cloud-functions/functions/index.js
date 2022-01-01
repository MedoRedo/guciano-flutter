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
  const query = request.query;
  const userId = query.userId;
  const order = query.order;

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
  const orderNumber = userDoc.data()['last_order_number'];

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
    delivery_method: order.deliveryMethod,
    payment_method: order.paymentMethod,
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

  // Update order status after some time.
  if (order.deliveryMethod == 'kiosk') {
    setTimeout(async function () {
      await orderRef.update({
        order_status: 'done'
      }).then({
        // TODO: Send a notification to the user.
      });
    }, 10000);
  } else if (order.deliveryMethod == 'dorm') {
    setTimeout(async function () {
      await orderRef.update({
        order_status: 'delivering'
      }).then({
        // TODO: Send a notification to the user.
      });

      setTimeout(async function () {
        await orderRef.update({
          order_status: 'done'
        }).then({
          // TODO: Send a notification to the user.
        });
      }, 10000);
    }, 10000);
  }

  // Return success.
  return response.status(200).json({
    message: 'Created order successfully.'
  });
});
