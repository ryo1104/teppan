import $ from 'jquery';
import { loadStripe } from '@stripe/stripe-js';

$(function() {
  $('.js-trade-new__stripe-checkout.btn.waves-effect').on('click', function (){
    let sId = $(this).attr("id");
    ToCheckout( sId );
  });
});

async function ToCheckout( sId ) {
  const stripe = await loadStripe('pk_test_p2Y9RrxY6Gjj2Bi43zhElMTp00hQwI9bNL');
  const { error } = await stripe.redirectToCheckout({
    sessionId: sId
  });
};