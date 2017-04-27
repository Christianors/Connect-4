$(document).ready(function() {

    
    $('.prefix').text(config.playerPrefix);
    $('#player').addClass(currentPlayer).text(config[currentPlayer + "PlayerName"]);

    
    $('.board button').click(function(e) {
        
        var y_pos = $('.board tr').index($(this).closest('tr'));
        var x_pos = $(this).closest('tr').find('td').index($(this).closest('td'));

        y_pos = dropToBottom(x_pos, y_pos);

        if (positionIsTaken(x_pos, y_pos)) {
            alert(config.takenMsg);
            return;
        }

        addDiscToBoard(currentPlayer, x_pos, y_pos);
        printBoard();

        if (verticalWin() || horizontalWin() || diagonalWin()) {
            $('.board button').unbind('click');
            $('.prefix').text(config.winPrefix);
            $('.play-again').show("slow");
            return;

        } else if (gameIsDraw()) {
            $('.board button').unbind('click');
            $('.message').text(config.drawMsg);
            $('.play-again').show("slow");
            return;
        }

        changePlayer();

        
        y_pos = 0;
        x_pos = tiraAi();
        $(' .indica').text("AI tiro en: " + x_pos);

        y_pos = dropToBottom(x_pos, y_pos);

        while (positionIsTaken(x_pos, y_pos)) {
            y_pos = 0;
            x_pos = tiraAi();
            $(' .indica').text("AI tiro en: " + x_pos);

            y_pos = dropToBottom(x_pos, y_pos);
        }

        addDiscToBoard(currentPlayer, x_pos, y_pos);
        printBoard();

        if (verticalWin() || horizontalWin() || diagonalWin()) {
            $('.board button').unbind('click');
            $('.prefix').text(config.winPrefix);
            $('.play-again').show("slow");
            return;

        } else if (gameIsDraw()) {
            $('.board button').unbind('click');
            $('.message').text(config.drawMsg);
            $('.play-again').show("slow");
            return;
        }


        changePlayer();
    });

    $('#facil').click(function(e) {
        location.reload();
    });
    $('#medio').click(function(e) {
        location.reload();
    });
    $('#dificil').click(function(e) {
        location.reload();
    });

});
