$(function(){
	const gameID = parseInt($('#game').data('id'));
	const groupSize = parseInt($('#game').data('groupSize'));
	let disableClick = false;

	$('.card-faces').filter(function(){
		return $(this).parent('.card').data().hasOwnProperty('solved');
	}).addClass('flipped').addClass('solved');

	$('.card-faces').click(processFlip);

	function processFlip() {
		if(disableClick) { return false; }
		$(this).addClass('flipped');

		let flippedCardFaces = $('.card-faces.flipped:not(.solved)');
		if(flippedCardFaces.length >= groupSize) {
			let flippedCardIDs = flippedCardFaces.map(function(){
				return $(this).parent('.card').data('id');
			}).get();
			let allFlippedCardsSame = _.uniq(flippedCardIDs).length == 1;
			if(allFlippedCardsSame) {
				cardID = _.first(flippedCardIDs);
				$.post(`/games/${gameID}/solve_card`, { card_id: cardID })
				.done(function(){
					flippedCardFaces.addClass('solved');
				})
				.fail(function(){
					// TODO should trigger an unobtrusive error modal
					alert('Could not save game.');
				});
			}
			else {
				disableClick = true;
				setTimeout(function(){ 
					flippedCardFaces.removeClass('flipped');
					disableClick = false;
				}, 2000);
			}
		}
	}
});