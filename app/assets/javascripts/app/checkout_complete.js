$(document).ready(function() {
  // ---------------------------------------------------------------------------
  // Share buttons
  // ---------------------------------------------------------------------------
  $('.fb-share-purchase').click(function(e) {
    FB.ui({
      method: 'share',
      href: 'https://gavoshop.wateraid.se',
    }, function(response){});

    mixpanel.track(
      "Share purchase on Facebook",
      {
        'order-payment-type': $('#purchase-tracking-info').attr('data-order-payment-type'),
        'order-id': $('#purchase-tracking-info').attr('data-order-id')
      }
    );

    ga('send', 'event', 'button', 'click', 'purchase-facebook-share');

    e.preventDefault();
  });

  $('.twitter-share-purchase').click(function(e) {
    mixpanel.track(
      "Share purchase on Twitter",
      {
        'order-payment-type': $('#purchase-tracking-info').attr('data-order-payment-type'),
        'order-id': $('#purchase-tracking-info').attr('data-order-id')
      }
    );

    ga('send', 'event', 'button', 'click', 'purchase-twitter-share');
  });
});
