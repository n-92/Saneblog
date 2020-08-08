% rebase('base.tpl')
<div class="container">
		<div class="help-block"></div>
		<div class="row col-md-12">
			<div style="text-align:center;">
				<input style="text-align:center;width: 100%;" type="text" id="titlebox" name="titlebox" placeholder="Title" required>
			</div>
		</div>
		<hr/>
		<div class="row col-md-12">
		 	<div id="summernote"></div>			
		</div>

		<div class="row col-md-6">
			<button id="submitText" class="btn btn-primary" type="button">Submit</button>
		</div>
</div>


<script>
	var date = new Date();
	$(document).ready(function() {
	    $('#summernote').summernote();
	 });

	$("#submitText").click(function() {
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.106:8889/post",
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