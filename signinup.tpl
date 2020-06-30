% rebase('base.tpl')
<div class="container">
	<div class="row">
		<div class="col">
			<h2>Sign In</h2>
			<form action="/signin" method="POST">
				<label for="email">email:</label>
				<input type="text" name="email" id="email" value="" />
				<label for="password">password:</label>
				<input type="password" name="password" id="password" value="" />
				<input type="submit" value="submit">
			</form>
		</div>
		
		<div class="w-100"></div>

		<div class="col">
			<h2>Sign Up</h2>
			<form action="/signup" method="POST">
				<label for="email">email:</label>
				<input type="text" name="email" id="email" value="" />
				<label for="password">password:</label>
				<input type="password" name="password" id="password" value="" />
				<input type="submit" value="submit">
			</form>
		</div>
	</div>
</div>