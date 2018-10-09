$(document).ready(function() {
  // Checkout form
  if ($('.checkout').length) {
    // Show and hide company fields
    function checkoutCompany() {
      if ($('.checkout__company input[type="checkbox"]').is(':checked')) {
        $('.checkout__company-fields, .checkout-payment').slideDown();
        $('.checkout__company-name').attr('data-parsley-required', '');
        $('.checkout__company-name').attr('data-parsley-required-message', 'Ange företagets namn.');
        $('.checkout__company-orgnr').attr('data-parsley-required', '');
        $('.checkout__company-orgnr').attr('data-parsley-required-message', 'Ange företagets orgnr.');
        $('.checkout__company-orgnr').attr('data-parsley-pattern', '^(\\d{6})\\-(\\d{4})$');
        $('.checkout__company-orgnr').attr('data-parsley-pattern-message', 'Orgnr är i fel format. Ex: 123456-1234');
      } else {
        $('.checkout__company-fields').slideUp();
        $('.checkout__payment--card').prop('checked', true);
        $('.checkout__company-name, .checkout__company-orgnr').removeAttr('data-parsley-required');
        $('.checkout__company-orgnr').removeAttr('data-parsley-pattern');
      }
      $('.checkout').parsley();
    }
    checkoutCompany();
    $('.checkout__company input[type="checkbox"]').change(function() {
      checkoutCompany();
    });

    // Alter form submit label depending on payment type
    function checkoutPayment() {
      var payment_type = $('.checkout__payment:checked').val().trim();
      if (payment_type == 'card') {
        $('.checkout__submit-invoice').hide();
        $('.checkout__submit-card').show();
        $('.checkout__submit-swish').hide();
        $('.checkout-stripe').slideDown();
        $('.checkout-swish-number').hide();
      } else if (payment_type == 'swish') {
        $('.checkout__submit-invoice').hide();
        $('.checkout__submit-card').hide();
        $('.checkout__submit-swish').show();
        $('.checkout-stripe').slideUp();
        $('.checkout-swish-number').show();
        $('.checkout__phone-swish').attr('data-parsley-required', '');
        $('.checkout__phone-swish').attr('data-parsley-required-message', 'Ange din telefon.');
      } else {
        $('.checkout__submit-card').hide();
        $('.checkout__submit-swish').hide();
        $('.checkout__submit-invoice').show();
        $('.checkout-stripe').slideUp();
        $('.checkout-swish-number').hide();
        $('.checkout__phone-swish').removeAttr('data-parsley-required');
      }
    }
    checkoutPayment();
    $('.checkout__payment').change(function() {
      checkoutPayment();
    });
  }

  $('.checkout__submit-card').on('click', function(e){
    e.preventDefault();
    if ($(this).parents('form').parsley().isValid()) {
      $this = $(this);
      handler.open({
        email: $('#order_donor_attributes_email').val(),
        description: $this.data('cards-count') + ' gåvobevis',
        panelLabel: 'Betala ' + $this.data('amount')
      });
    } else {
      $(this).parents('form').parsley().validate()
    }
  });

});
