% rebase('base.tpl')
<div>
	<input type="text" id="titlebox" name="titlebox" value="{{!title}}">
</div>
<div id="summernote"></div>

<button id="save" type="button">Save</button>

<script>
	var date = new Date();

	$(document).ready(function(){
		$('#summernote').summernote('pasteHTML', '{{!article_text}}');
	});

	$("#save").click(function() {
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.103:8889/save",
		  	data: JSON.stringify({
					title: 			$("#titlebox").val(),
					articleText: 	$('#summernote').summernote('code'),
					postguid: 		window.location.href.split('/').slice(-1)[0],
					dateUpdated: 	date.toISOString().slice(0, 19).replace('T', ' '),
			 })
		  }).done( function(data) {   	
				console.log(data["record"])
	 	});
	});
</script>