$(document).ready(function() {
  
  $('#send-tweet').on('submit', function(e) {
    e.preventDefault();
    $('#status p').text('Processing Tweet....');

    var form_data = $(this).serialize();

    $('input[name="tweet"]').attr('disabled', 'disabled');
    $('input[type="submit"]').attr('disabled', 'disabled');
    $('input[type="delay"]').attr('disabled', 'disabled');

    $.ajax({
      url: '/',
      method: 'POST',
      data: form_data

    }).done(function(response) {
      waitUntilDone(response);
    });


    function waitUntilDone(jobID) {

      function update_home_page() {
        var tweet = $('input[name="tweet"]').val();
        $('input[name="tweet"]').val('');
        $('#status p').text('Successfully sent tweet!');
        $('#tweeters').append('<li>' + tweet + '</li>');
        $('input[name="tweet"]').removeAttr('disabled');
        $('input[name="delay"]').removeAttr('disabled');
        $('input[type="submit"]').removeAttr('disabled');
      }

      $.ajax({
        url: "/status/" + jobID,
        type: "GET"
      }).done(function(status) {

        if (status === "success") {
          update_home_page();
      } else {
        setTimeout(function() {
          waitUntilDone(jobID);
        }, 1000);
      }

      });
    }
  });
});

