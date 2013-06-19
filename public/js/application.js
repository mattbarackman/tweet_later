$(document).ready(function() {
  $('#send-tweet').on('submit', function(e){
    e.preventDefault();
    $('#status p').text('Processing Tweet....');
    var tweet = $('input[name="tweet"]').val();
    $('input[name="tweet"]').val('');
    $('input[name="tweet"]').attr('disabled', 'disabled');
    $('input[type="submit"]').attr('disabled', 'disabled');
 
    $.ajax({
      url: '/',
      method: 'POST',
      data: {tweet: tweet}

    }).done(function(job_id){
      var jobID = job_id;
 
      $.ajax({
        url: "/status/" + jobID,
        type: "GET"
      }).done(function(status){
    
      if (status === "true"){
        $('#status p').text('Successfully sent tweet!');
        $('#tweeters').append('<li>' + tweet + '</li>');
      }
      else {
        $('#status p').text("What'd you do wrong bro!");
      }
      $('input[name="tweet"]').removeAttr('disabled');
      $('input[type="submit"]').removeAttr('disabled');
           
      });
    });

  });
});
