Foundation.global.namespace = '';
$(document).foundation();

$(document).ready(function(){
  // SVG fallback --------------------------------------------------------------
  if (!Modernizr.svg) {
    $("img[src$='.svg']").each(function() {
      $(this).attr("src", $(this).data('fallback'));
    });
  };

  // Skrollr init
  skrollr.init({
      forceHeight: false,       
      mobileCheck: function() {
          //hack - forces mobile version to be off
          return false;
      }
  });
});

$(function() {
  $('.show-checkout-form').on('click', function(e) {
    e.preventDefault();

    $(this).hide();
    $('.index__checkout-form, .index__checkout-steps').slideDown('medium');
  });

  $('.alert-box .close').on('click', function(e) {
    e.preventDefault();

    $('.alert-box').fadeOut();
  });

  $('#submit_form').on('click', function() { $('.edit_order').submit(); });

  $('.card-custom').on('click', function() {
    $('#new_custom_amount').val($('#custom_amount').val());
  });


  // Validate Swedish Personal Identity Number (personnummer) using checksum
  // Note: this is somewhat simplified because it does not take into account
  // that the date of the number is valid (e.g. "000000-0000" does return as true)
  // https://gist.github.com/stpe/aebc00b9ad361d93f33d
  var isValidSwedishPIN = function(pin) {
    // Test numbers are valid, too
    if (pin === '191111111111' || pin === '191111111112') {
      return true;
    }

    pin = pin
    .replace(/\D/g, "")     // strip out all but digits
    .split("")              // convert string to array
    .reverse()              // reverse order for Luhn
      .slice(0, 10);          // keep only 10 digits (i.e. 1977 becomes 77)

    // verify we got 10 digits, otherwise it is invalid
    if (pin.length != 10) {
      return false;
    }

    var sum = pin
    // convert to number
    .map(function(n) {
      return Number(n);
    })
    // perform arithmetic and return sum
    .reduce(function(previous, current, index) {
      // multiply every other number with two
      if (index % 2) current *= 2;
      // if larger than 10 get sum of individual digits (also n-9)
      if (current > 9) current -= 9;
      // sum it up
      return previous + current;
    });

    // sum must be divisible by 10
    return 0 === sum % 10;

  };

  $("#fetch-personal-number-input").on('keyup', function(event) {
    // Prevent non numeric chars from beeing entered
    if(event.which != 8 && isNaN(String.fromCharCode(event.which))){
      event.preventDefault();
    }

    // Let the user type a bit first....
    if ($(this).val().length < 12 && event.keyCode != 13) {
      return;
    } else {
      // Check if personal number
      if (isValidSwedishPIN($('#fetch-personal-number-input').val())) {
        $('#fetch-personal-number-button').addClass('active');
        $('#fetch-personal-number-button').removeAttr("disabled");
        $('#fetch-personal-number-input').next().empty();
      } else {
        $('#fetch-personal-number-button').removeClass('active');
        $('#fetch-personal-number-button').attr("disabled", "disabled");
        $('#fetch-personal-number-input').next().html("<li class='parsley-required'>Ange ett giltigt personnummer.</li>");
        $('#fetch-personal-number-input').next().addClass('filled');
      }
    }
  });

  // ---------------------------------------------------------------------------
  // Fetch personal infromation and prefill fields
  // ---------------------------------------------------------------------------
  $('#fetch-personal-number-button').on('click', function(e) {
    e.preventDefault();

    var prefillButton = $("#fetch-personal-number-button");

    prefillButton.attr("disabled", "disabled");

    var personalNumber = $("#fetch-personal-number-input").val();

    if (personalNumber) {
      $.post("/persons", { id: personalNumber }, function (result) {
        console.log(result);

        $("#order_donor_attributes_first_name").val(result.first_name);
        $("#order_donor_attributes_last_name").val(result.last_name);
        $("#order_donor_attributes_address").val(result.address_1);
        $("#order_donor_attributes_post_code").val(result.post_code);
        $("#order_donor_attributes_city").val(result.city);

        $("#fetch-personal-number-input").next().empty();

        prefillButton.removeAttr("disabled");

      }).fail(function(error) {
        // Set error text depending on error message
        if (error.status == '404') {
          console.log('WRONG');
          $("#fetch-personal-number-input").prev().html("<li class='parsley-required'>Hittade inga uppgifter för detta personnummer.</li>");
        } else {
          console.log('WRONGs');
          $("#fetch-personal-number-input").prev().html("<li class='parsley-required'>Ange ett giltigt personnummer.</li>");
        }

        prefillButton.removeAttr("disabled");
      });
    }
  });
});

$(document).on('opened.fndtn.reveal', '[data-reveal]', function () {
  $('html,body').animate({ scrollTop: 0 }, 'slow');
});
