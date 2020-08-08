% rebase('base.tpl')

<div class="container">
	<h1> Posts </h1>
	
	<div class="row">
		%if posts:
	      %for post in posts:
	        	<div class="mt-5"> {{!post[0]}} </div>
	        	<input type="text" id="postguid" name="postguid" hidden value="{{!post[1]}}" />
				<button id="likePost" type="button">Like [{{like_count}}]</button>
	        	<hr/>
	        %end
	     %end
	 </div>
	
	<div class="row" id="commentlist">
	     %if comments:
	      %for comment in comments:
	        	<div class="mt-5"> {{!comment[0]}} </div>
	        	<div class="mt-5"> {{!comment[1]}} </div>
	        	<div class="mt-5"> {{!comment[2]}} </div>
	        	<button id="deletecomment" value="{{!comment[3]}}">Delete</button>
	        	<hr/>
	        %end
	     %end
	</div>

	<div class="row">
	     	<textarea name="comment" id="comment"></textarea>
	     	
	 </div>
	 <div class="row">
	     	<button id="postcomment">Comment</button>
	 </div>

    
</div>
 

 <script type="text/javascript">
     	var date = new Date();
     	$("#likePost").click(function() {
		$.ajax({
			  	type: "POST",
				contentType: "application/json; charset=utf-8",
			  	url:"http://192.168.0.106:8889/like",
			  	data: JSON.stringify({
			  		postguid: $("#postguid").val(),
					dateCreated: date.toISOString().slice(0, 19).replace('T', ' '),
			 	})
		 	 }).done( function(data) {   	
				console.log(data["record"])
				if(data["record"] == "liked_already"){
					alert("You have already liked this post")
				}
	 		});
		});

		$("#postcomment").click(function() {
		$.ajax({
			  	type: "POST",
				contentType: "application/json; charset=utf-8",
			  	url:"http://192.168.0.106:8889/comment",
			  	data: JSON.stringify({
			  		postguid: window.location.href.split('/').slice(-1)[0],
			  		comment: $("#comment").val(),
					dateCreated: date.toISOString().slice(0, 19).replace('T', ' '),
			 	})
		 	 }).done( function(data) {   	
				console.log(data["record"])
				if(data["record"] == "comment_success"){
					alert("Comment posted")
				}
	 		});
		});

		$("button#deletecomment").click(function() {
		alert(this.id);
		alert(this.value);
			$.ajax({
			  	type: "POST",
				contentType: "application/json; charset=utf-8",
			  	url:"http://192.168.0.106:8889/deletecomment",
			  	data: JSON.stringify({
						commentguid: this.value,

				 })
			  }).done( function(data) {   	
					console.log(data["record"])
		 	});
		});
     </script>