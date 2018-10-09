$(document).ready(function() {
  $('.product__actions__button').on('click', function() {
    fbq('track', "AddToWishlist");
    console.log('AddToWishlist');
  });

  $('.add-item__footer .btn').on('click', function() {
    fbq('track', "AddToCart");
    console.log('AddToCart');
  });

  $('.checkout__submit-card').on('click', function() {
    fbq('track', "AddPaymentInfo");
    console.log('AddPaymentInfo');
  });
});