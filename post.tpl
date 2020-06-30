% rebase('base.tpl')
<div>
	<input type="text" id="titlebox" name="titlebox">
</div>
<div id="summernote"></div>

<button id="submitText" type="button">Submit</button>

<script>
	var date = new Date();
	$(document).ready(function() {
	    $('#summernote').summernote();
	 });

	$("#submitText").click(function() {
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.103:8889/post",
		  	data: JSON.stringify({
					title: 			$("#titlebox").val(),
					articleText: 	$('#summernote').summernote('code'),
					dateCreated : 	date.toISOString().slice(0, 19).replace('T', ' '),
					dateUpdated: 	date.toISOString().slice(0, 19).replace('T', ' '),
			 })
		  }).done( function(data) {   	
				console.log(data["record"])
	 	});
	});
</script>




