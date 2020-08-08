% rebase('base.tpl')
<div class="container">
	<div class="help-block"></div>
	<div style="text-align:center;">
		<input style="text-align:center;width: 100%;" type="text" id="titlebox" name="titlebox" placeholder="Title" value="{{!title}}"required>
	</div>
	<hr/>
	<div id="summernote"></div>

	<button class="btn btn-primary" id="save" type="button">Save</button>
</div>


<script>
	var date = new Date();

	$(document).ready(function(){
		$('#summernote').summernote('pasteHTML', '{{!article_text}}');
	});

	$("#save").click(function() {
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.106:8889/save",
		  	data: JSON.stringify({
					title: 			$("#titlebox").val(),
					articleText: 	$('#summernote').summernote('code'),
					postguid: 		window.location.href.split('/').slice(-1)[0],
					dateUpdated: 	date.toISOString().slice(0, 19).replace('T', ' '),
			 })
		  }).done( function(data) {   	
				alert(data["record"]==1?"Update success":"Error encountered")
	 	});
	});
</script>