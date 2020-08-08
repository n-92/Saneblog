%rebase('base.tpl')
<div class="container">
<div class="col-12">
	<div class="row">
		<form action="/signin" method="POST">
			<div class="form-row">
				<div class="row form-group">
					<h2 style="text-align:center;">Sign In</h2>
				</div>
			 	<div class="form-group col-md-6">
			      <label for="email">Email</label>
			      <input type="email" class="form-control" name="email" id="email"placeholder="Email">
			    </div>
			</div>
			<div class="form-row">
			 	<div class="form-group col-md-6">
			      <label for="password">Password</label>
			       <input type="password" class="form-control" name="password" id="password" value="" placeholder="Password">
			    </div>
			</div>
			<div class="form-group col-md-6">
				<input type="submit" class="btn btn-primary" value="Sign In">
			</div>
		</form>
	</div>
	<div class="help-block"></div>
	<div class="row">
		<form action="/signup" method="POST">
			<div class="form-row">
				<div class="row form-group">
					<h2 style="text-align:center;">Register</h2>
				</div>
			 	<div class="form-group col-md-6">
			      <label for="email">Email</label>
			      <input type="email" class="form-control" name="email" id="email"placeholder="Email">
			    </div>
			</div>
			<div class="form-row">
			 	<div class="form-group col-md-6">
			      <label for="password">Password</label>
			       <input type="password" class="form-control" name="password" id="password" value="" placeholder="Password">
			    </div>
			</div>
			<div class="form-group col-md-6">
				<input type="submit" class="btn btn-primary" value="Register">
			</div>
		</form>
	</div>
</div>
</div>
