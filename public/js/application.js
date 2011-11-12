$(document).ready(function() {
  // Give the focus to the input text field
  $("form input:first").focus();

  $("form input[type=text]").keydown(function(event) {
    // Disable the Return key
    if (event.which == 13) { event.preventDefault(); };
  });

  $("form input[type=text]").keyup(function(event) {
    // This code checks if the caret is at the start/end of the line
    // Taken from: http://stackoverflow.com/questions/3904530/jquery-if-cursor-position-at-the-start-end-in-a-textfield#answer-3904819
    var textInput = document.getElementById("number"), val = textInput.value;
    var isAtStart = false, isAtEnd = false;
    if (typeof textInput.selectionStart == "number") {
      // Non-IE browsers
      isAtStart = (textInput.selectionStart == 0);
      isAtEnd = (textInput.selectionEnd == val.length);
    } else if (document.selection && document.selection.createRange) {
      // IE branch
      textInput.focus();
      var selRange = document.selection.createRange();
      var inputRange = textInput.createTextRange();
      var inputSelRange = inputRange.duplicate();
      inputSelRange.moveToBookmark(selRange.getBookmark());
      isAtStart = inputSelRange.compareEndPoints("StartToStart", inputRange) == 0;
      isAtEnd = inputSelRange.compareEndPoints("EndToEnd", inputRange) == 0;
    }
    // ---

    if ($(this).val().match(/[^0-9a-f]+/i))
    {
      if ($("#error").length == 0)
      {
        $("section#container h1").after("<p id=\"error\" class=\"flash\">Invalid number.</p>");
      }

      return false;
    }
    else
    {
      var error = $("p#error.flash");
      if (error.length > 0)
      {
        error.fadeOut("slow", function(){
          $(this).remove();
        });
      }
    }

    if (// if the key pressed is between 0 and 9
        (event.which >= 48 && event.which <= 57) ||

        // if the key pressed is between a and f
        (event.which >= 65 && event.which <= 70) ||

        // if the Backspace key is pressed and the caret
        // is not at the start of the text field
        (event.which == 8 && isAtStart == false) ||

        // if the Delete key is pressed and the caret
        // is not at the end of the text field
        (event.which == 46 && isAtEnd == false))
    {
      var base = $("form :radio").filter(":checked").val();

      if (base == undefined)
      {
        var url_string = "/" + $(this).val();
      }
      else
      {
        var url_string = "/" + base + "/" + $(this).val();
      }

      $.ajax({
        type : "GET",
        url  : url_string,
        dataType : "html",
        success : function(data) {
          var output = $("section#output");
          if (output.length > 0)
          {
            output.remove();
          }

          $("form").after(data);
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
          var error = $("p#error.flash");
          if (error.length > 0)
          {
            error.remove();
          }
          $("section#container h1").after("<p id=\"error\" class=\"flash\">Invalid request.</p>");

        }

      });
    }
  });

  $("form :radio").click(function(){
    var error = $("p#error.flash");
    if (error.length > 0)
    {
      error.fadeOut("slow", function(){
        $(this).remove();
      });
    }

    var number = $("form #number").val();
    if (number != "")
    {

      $.ajax({
        type : "GET",
        url  : "/" + $(this).val() + "/" + number,
        dataType : "html",
        success : function(data) {
          var output = $("section#output");
          if (output.length > 0)
          {
            output.remove();
          }

            $("form").after(data);
        },
        error : function(XMLHttpRequest, textStatus, errorThrown) {
          var error = $("p#error.flash");
          if (error.length > 0)
          {
            error.remove();
          }
          $("section#container h1").after("<p id=\"error\" class=\"flash\">Invalid request.</p>");

        }

      });
    }
  });
});
