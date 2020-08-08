% rebase('base.tpl')
<div class="container">
	<h1> Posts </h1>
	
		%for gt in guidsTitlesList:
			<input type="input" name="postguid" id="postguid" hidden value="{{!gt[0]}}">
			<h3><a href="http://192.168.0.106:8889/getposts/{{!gt[0]}}">{{!gt[1]}}</a></h3>
			<a href="http://192.168.0.106:8889/update/{{!gt[0]}}">Edit</a>
			||
			<a id="deletepost" data-value="{{!gt[0]}}">Delete</a>
			
			<div>
				<a>Date: {{!gt[2]}}</a>	
				||
				<a>Posted by: {{!gt[3].replace(gt[3][:18],'****') }}</a>
			</div>
			<hr>
    	%end
	
</div>

<script>
	var date = new Date();
	
	$("a#deletepost").click(function() {
		// alert(this.id);
		// alert($(this).data("value"));
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.106:8889/delete",
		  	data: JSON.stringify({
					postguid: $(this).data("value"),

			 })
		  }).done( function(data) {   	
				//console.log(data["record"])
				alert(data["record"]?"Success":"Can't be deleted");
	 	});
	});

</script>