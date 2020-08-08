% rebase('base.tpl')
<div class="container">
	<h1> Posts </h1>
	<ul>
		%for gt in guidsTitlesList:
			<input type="input" name="postguid" id="postguid" hidden value="{{!gt[0]}}">
			<li><a href="http://192.168.0.106:8889/getposts/{{!gt[0]}}">{{!gt[1]}}</a></li>
			<a href="http://192.168.0.106:8889/update/{{!gt[0]}}">Edit</a>
			<!-- <button id="deletepost" value="{{!gt[0]}}">Delete</button> -->
			<a id="deletepost" data-value="{{!gt[0]}}">Delete</a>
			
    	%end
	</ul>
</div>

<script>
	var date = new Date();
	
	$("a#deletepost").click(function() {
		alert(this.id);
		alert($(this).data("value"));
		$.ajax({
		  	type: "POST",
			contentType: "application/json; charset=utf-8",
		  	url:"http://192.168.0.106:8889/delete",
		  	data: JSON.stringify({
					postguid: $(this).data("value"),

			 })
		  }).done( function(data) {   	
				console.log(data["record"])
	 	});
	});

	// $("button#updatepost").click(function() {
	// 	alert(this.id);
	// 	alert(this.value);
	// 	$.ajax({
	// 	  	type: "GET",
	// 		contentType: "application/json; charset=utf-8",
	// 	  	url:"http://192.168.0.106:8889/update/"+this.value,
	// 	  //data: JSON.stringify({
	// 			// 	postguid: this.value,
	// 	  // })
	// 	  }).done(function(data) {   	
	// 			$("html").html(data);
	//  	});
	// });
</script>