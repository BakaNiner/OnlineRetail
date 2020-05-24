from flask import Flask, request, session
import pymssql
import hashlib
import time
import ast

app = Flask(__name__)
app.config['SECRET_KEY'] = "secret_key"
conn = pymssql.connect("127.0.0.1", "sa", "reallyStrongPwd123", "OnlineRetail")
conn.autocommit(True)
cursor = conn.cursor()

def checkUsername(username):
	if username is "":
		return "用户名不能为空"
	if not username.isalnum():
		return "含有非法字符，请使用数字和字母"
	cursor.execute("select userName from Customer")
	allUsername = cursor.fetchall()
	if (username,) in allUsername:
		return "用户名已被注册"
	else:
		return "用户名未被使用"

@app.route("/checkUsername", methods=["post"])
def checkUsernameGate():
	username = request.form["username"]
	return checkUsername(username)

@app.route('/')
def loginGate():
	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> Online Retail </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<style type=text/css>
			div {
				width: 300px;
				height: 100px;
				position: absolute;
				left: 50%;
				top: 50%;
				margin: -150px 0 0 -150px;
			}
		</style>
	</head>
	<body>
	<div>
	<form action="/index" method="post">
		用户名：<input type=text name="username" id="inputUsername" maxlength="15" size="22"><br><span id='Hint'></span><br>
		密码：<input type=password name="pwd" maxlength="20" size="22"><br><br>
		<input type=submit name="register" id="regButton" value="注册">
		<input type=submit name="login" id="loginButton" value="登录">
	</form>
	</div>
	<script type="text/javascript">
		$("#inputUsername").blur(function(){
			var username = $(this).val();
			$.post("/checkUsername", {username:username}, function(result) {
				$("#Hint").html(result);
			});
		});
		$("#regButton").on("click", function() {
			state = $("#Hint").html();
			if(state != "用户名未被使用") {
				alert(state)
				return false;
			} else
				return true;
		});
		$("#loginButton").on("click", function() {
			state = $("#Hint").html();
			if(state == "") {
				$.post("/checkUsername", {username:username}, function(result) {
					$("#Hint").html(result);
				});
			}
			if(state != "用户名已被注册") {
				alert(state)
				return false;
			} else
				return true;
		});
	</script>
	</body>
	</html>
	'''
	return html

@app.route('/comment', methods = ["get"])
def commentGate():
	idx = request.args["idx"]
	if not idx.isdigit():
		return "错误商品id"

	cursor.execute("select productName from Product where productID = {0}".format(idx))
	res = cursor.fetchall()
	if len(res) == 0:
		return "错误商品id"
	goodname = res[0][0]
	cursor.execute("select userName, grade, comment, reviewTime from Review, Customer where productID = {0} and reviewerID = customerID".format(idx))
	comments = cursor.fetchall()

	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> 商品{0}的评论 </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<style type=text/css>
			.comment{{ border-top:1px solid black; }}
		</style>
	</head>
	<body>
	'''.format(goodname)

	if not comments:
		html += '''
			暂无评价
		'''
	else:
		for userName, grade, comment, reviewTime in comments:
			# 这边可能要改成username
			html += '''
				<div class="comment">
				<h3> 用户{0}***{1} </h3>
			'''.format(str(userName)[0], str(userName)[-1])
			html += "<p>" + "★" * grade + "☆" * (5 - grade) + " " + reviewTime + "</p>"
			html += "<p>{0}</p>".format(comment)
			html += '''
				</div>
			'''

	html += '''
	</body>
	</html>
	'''
	return html

@app.route('/commitComment', methods = ["post"])
def commitCommentGate():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录！"

	idx = request.form["idx"]
	text = request.form["text"]
	rate = request.form["rate"]
	if text == "":
		return "评价不能为空"
	if not idx.isdigit():
		return "错误商品id"

	cursor.execute("select productName from Product where productID = {0}".format(idx))
	res = cursor.fetchall()
	if len(res) == 0:
		return "错误商品id"

	reviewTime = time.strftime('%Y-%m-%d',time.localtime(time.time()))
	cursor.execute("insert into Review values ({0}, {1}, {2}, '{3}', '{4}')".format(userid, idx, rate, text, reviewTime))
	return "发表评论成功"

@app.route('/makeComment', methods = ["get"])
def makeCommentGate():
	idx = request.args["idx"]
	if not idx.isdigit():
		return "错误商品id"

	cursor.execute("select productName from Product where productID = {0}".format(idx))
	res = cursor.fetchall()
	if len(res) == 0:
		return "错误商品id"
	goodname = res[0][0]

	# TBD 给出customerID和productID，判断这个人有没有买过这个商品
	cursor.execute("")

	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> 撰写商品{0}的评论 </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
	</head>
	<body>
	'''.format(goodname)

	html += '''
	<div align="center">
		<textarea id="text" style="width:820px;height:400px;resize:none;font-size:16px;"></textarea>
		<br>
		评分：<select id="rate">
			<option value="0">0</option>
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
		</select>
		<br> <br>
		<input id="commit" type="submit" value="发表评论"/>
	</div>
	<script type="text/javascript">
		$("#commit").on("click", function() {{
			var text = $("#text").val();
			var rate = $("#rate").val();
			$.post("/commitComment", {{idx:{0}, text:text, rate:rate}}, function(result) {{
				alert(result);
				window.location.href = "/comment?idx={0}";
			}});
		}});
	</script>
	'''.format(idx)
	return html

@app.route('/order', methods = ["get"])
def orderGate():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录！"

	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> Online Retail </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<style type=text/css>
			.order{ border-top:5px solid black; }
			.goods{ width:1000px; height:300px; margin:50px auto; border:solid 1px gray; overflow:hidden; }
			.photo{ float:left; width:400px; height:300px; text-align:center; }
			.photo img{ display:block; width:auto; height:auto; max-width:100%; max-height:100%; margin:0 auto; }
			.intro{ float:right; width:550px; }
		</style>
	</head>
	<body>
	'''

	# 账号信息
	html += '''
		<h1> 用户{0}的所有订单 </h1>
	'''.format(username)

	# 读取商品信息
	cursor.execute("select orderID, shippingAddressID, totalAmount, orderDate, is_complete from OrderTable where customerID = {0}".format(userid))
	orders = cursor.fetchall()
	for orderID, shippingAddressID, totalAmount, orderDate, is_complete in orders:
		html += '''
			<div class="order">
			<h1> 订单号：{0} </h1>
		'''.format(orderID)

		cursor.execute("select itemID, productName, quantity, productFigure from OrderItem, Product where orderID = {0} and OrderItem.itemID = Product.productID".format(orderID))
		goods = cursor.fetchall()
		for idx, goodname, quantity, imageurl in goods:
			html += '''
					<div class="goods">
						<div class="photo"><img src="{3}"></div>
						<div class="intro">
							<h3> {1} </h3>
							<p> 已买：{2}</p>
						</div>
					</div>
			'''.format(idx, goodname, quantity, imageurl)

		cursor.execute("select streetAddress, cityName, provinceName, postalCode, phoneNumber from ShipAddress where addressID = {0}".format(shippingAddressID))
		streetAddress, cityName, provinceName, postalCode, phoneNumber = cursor.fetchall()[0]
		html += '''
			<p> 收货地址：街道：{0}，城市：{1}，省份：{2}，邮政编码：{3}，联系方式：{4} </p>
			<p> 总额：{5} </p>
			<p> 下单时间：{6} </p>
			<p> 是否完成：{7} </p>
			</div>
		'''.format(streetAddress, cityName, provinceName, postalCode, phoneNumber, totalAmount, orderDate, "未完成" if is_complete == '0' else "已完成")

	html += '''
	</body>
	</html>
	'''
	return html

@app.route('/commitOrder', methods = ["post"])
def commitOrderGate():
	username = session.get("username")
	userid = session.get("userid")
	cart = session.get("{0}_cart".format(userid))
	if username is None:
		return "您未登录"
	if cart is None:
		return "您未提交订单"

	cursor.execute("create table #tempCart(productID INT, productNumber INT)")
	for idx, goodname, price, number, stock in cart:
		cursor.execute("insert into #tempCart values ({0}, {1})".format(idx, number))

	cursor.execute("select stockAmount from Product where productID = {0}".format(cart[0][0]))
	beforeStock = cursor.fetchall()[0][0]

	cursor.execute("""
	               update Product set stockAmount = stockAmount - productNumber, saleAmount = saleAmount + productNumber from #tempCart
	               where Product.productID = #tempCart.productID and not exists(
	               select * from Product, #tempCart where Product.productID = #tempCart.productID and productNumber > stockAmount)""")
	cursor.execute("drop table #tempCart")

	cursor.execute("select stockAmount from Product where productID = {0}".format(cart[0][0]))
	afterStock = cursor.fetchall()[0][0]
	if afterStock == beforeStock:
		session.pop("{0}_cart".format(userid))
		return "有商品供货不足"

	streetAddress = request.form["streetAddress"]
	cityName = request.form["cityName"]
	provinceName = request.form["provinceName"]
	postalCode = request.form["postalCode"]
	phoneNumber = request.form["phoneNumber"]
	is_default = request.form["is_default"]

	if is_default == "1":
		cursor.execute("update ShipAddress set is_default = '0' where customerID = {0} and is_default = '1'".format(userid))

	cursor.execute("insert into ShipAddress values ('{0}', '{1}', '{2}', '{3}', {4}, '{5}', '{6}') select @@IDENTITY".format(streetAddress, cityName, provinceName, postalCode, userid, phoneNumber, is_default))
	# cursor.execute("select addressID from ShipAddress where")
	addressID = cursor.fetchall()[0][0]

	totalAmount = sum(list(map(lambda x : x[2] * x[3], cart)))
	orderDate = time.strftime('%Y-%m-%d',time.localtime(time.time()))
	cursor.execute("insert into OrderTable values ({0}, {1}, {2}, '{3}', 0) select @@IDENTITY".format(addressID, userid, totalAmount, orderDate))
	orderID = cursor.fetchall()[0][0]

	for idx, goodname, price, number, stock in cart:
		cursor.execute("insert into OrderItem values ({0}, {1}, {2}, {3})".format(orderID, idx, number, price * number))

	for idx, goodname, price, number, stock in cart:
		cursor.execute("delete from ShoppingCart where customerID = {0} and productID = {1}".format(userid, idx))

	session.pop("{0}_cart".format(userid))
	return "订单提交成功"

@app.route('/createOrder', methods = ["post"])
def createOrder():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录"

	if len(request.form) == 0:
		return "您未选择所要购买物品"

	html = '''
		<!DOCTYPE html>
		<html>
		<head>
			<meta charset="UTF-8">
			<title> Online Retail </title>
			<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
			<style type=text/css>
				.goods{ width:400px; height:100px; margin:50px auto; border:solid 1px gray; overflow:hidden; }
				.intro{ float:left; width:300px; margin:0 50px 0 50px; }
				.address{ width:400px; height:500px; margin:50px auto; }
			</style>
		</head>
		<body>
		'''

	html += '''
		<h1> 新建订单 </h1>
	'''

	cursor.execute("select ShoppingCart.productID, productName, productPrice, productQuantity, stockAmount from ShoppingCart, Product where customerID = {0} and ShoppingCart.productID = Product.productID".format(userid))
	cart = cursor.fetchall()
	cart = list(filter(lambda x : request.form.get("{}_checkbox".format(x[0])) is not None, cart))
	session["{0}_cart".format(userid)] = cart

	for idx, goodname, price, number, stock in cart:
		html += '''
			<div class="goods">
				<div class="intro">
					<h3> {1} </h3>
					<p> 价格：{2}，购买：{3}件，库存：{4}件 </p>
				</div>
			</div>
		'''.format(idx, goodname, price, number, stock)

	# 获取默认地址
	cursor.execute("select streetAddress, cityName, provinceName, postalCode, phoneNumber from ShipAddress where customerID = {0} and is_default = 1".format(userid))
	defaultAddress = cursor.fetchall()

	if not defaultAddress:
		html += '''
			<div class="address" align="center">
			街道：<input type=text id="streetAddress"> <br> <br>
			城市：<input type=text id="cityName"> <br> <br>
			省份：<input type=text id="provinceName"> <br> <br>
			邮政编码：<input type=text id="postalCode"> <br> <br>
			联系方式：<input type=text id="phoneNumber"> <br> <br>
			设为默认地址：<input type=checkbox id="is_default"> <br> <br>
			<input type=button id="commit" value="提交订单">
			</div>
		'''
	else:
		street, city, province, post, phone = defaultAddress[0]
		html += '''
			<div class="address" align="center">
			街道：<input type=text id="streetAddress" value="{0}"> <br> <br>
			城市：<input type=text id="cityName" value="{1}"> <br> <br>
			省份：<input type=text id="provinceName" value="{2}"> <br> <br>
			邮政编码：<input type=text id="postalCode" value="{3}"> <br> <br>
			联系方式：<input type=text id="phoneNumber" value="{4}"> <br> <br>
			设为默认地址：<input type=checkbox id="is_default" checked="checked"> <br> <br>
			<input type=button id="commit" value="提交订单">
			</div>
		'''.format(street, city, province, post, phone)

	html += '''
		<script type="text/javascript">
			$("#commit").on("click", function() {
				var streetAddress = $("#streetAddress").val();
				var cityName = $("#cityName").val();
				var provinceName = $("#provinceName").val();
				var postalCode = $("#postalCode").val();
				var phoneNumber = $("#phoneNumber").val();
				var is_default = "0";
				if($("#is_default").prop("checked") == true)
					is_default = "1";

				$.post("/commitOrder", {streetAddress:streetAddress, cityName:cityName, provinceName:provinceName, postalCode:postalCode, phoneNumber:phoneNumber, is_default:is_default}, function(result) {
					alert(result);
					window.location.href = "/order";
				});
			});
		</script>
	'''

	html += '''
	</body>
	</html>
	'''

	return html

@app.route('/add2cart', methods = ["post"])
def add2cartGate():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录！"

	idx = request.form["idx"]
	number = request.form["number"]
	if not number.isdigit():
		return "添加购物车失败！请检查数量是否正确"

	addtime = time.strftime('%Y-%m-%d',time.localtime(time.time()))
	cursor.execute("select * from ShoppingCart where customerID = {0} and productID = {1}".format(userid, idx))
	res = cursor.fetchall()
	if res:
		cursor.execute("update ShoppingCart set productQuantity = productQuantity + {2}, addTime = '{3}' where customerID = {0} and productID = {1}".format(userid, idx, number, addtime))
	else:
		cursor.execute("insert into ShoppingCart values ({0}, {1}, {2}, '{3}')".format(userid, idx, number, addtime))
	return "添加购物车成功"

@app.route('/removeCart', methods = ["post"])
def removeCartGate():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录！"

	idx = request.form["idx"]
	cursor.execute("delete from ShoppingCart where customerID = {0} and productID = {1}".format(userid, idx))
	return "移出成功"

@app.route('/cart', methods = ["get"])
def cartGate():
	username = session.get("username")
	userid = session.get("userid")
	if username is None:
		return "您未登录！"

	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> Online Retail </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<style type=text/css>
			.goods{ width:1000px; height:300px; margin:50px auto; border:solid 1px gray; overflow:hidden; }
			.photo{ float:left; width:400px; height:300px; text-align:center; }
			.photo img{ display:block; width:auto; height:auto; max-width:100%; max-height:100%; margin:0 auto; }
			.intro{ float:right; width:550px; }
		</style>
	</head>
	<body>
	'''

	# 账号信息
	html += '''
		<h1> 用户{0}的购物车 </h1>
		<form action="/createOrder" method="post">
	'''.format(username)

	cursor.execute("""
				   select ShoppingCart.productID, productName, productPrice, productFigure, productQuantity, addTime, stockAmount
	 			   from ShoppingCart, Product
	 			   where customerID = {0} and ShoppingCart.productID = Product.productID""".format(userid))
	cart = cursor.fetchall()

	# 读取购物车
	for idx, goodname, price, image, number, addtime, stock in cart:
		html += '''
			<div class="goods">
				<div class="photo"><img src="{3}"></div>
				<div class="intro">
					<h3> {1} </h3>
					<p> 价格：{2}，购买：{4}件，库存：{6}件 </p>
					<p> 加入时间：{5} </p>
					是否购买：<input type=checkbox name="{0}_checkbox" style="height:20px; width:20px;">
					<br><br><input type=button id="{0}_remove" value="移出购物车">
				</div>
				<script type="text/javascript">
					$("#{0}_remove").on("click", function() {{
						$.post("/removeCart", {{idx:{0}}}, function(result) {{
							alert(result);
							window.location.reload();
						}});
					}});
				</script>
			</div>
		'''.format(idx, goodname, price, image, number, addtime, stock)

	if cart:
		html += '''
		<div align="center"><input type=submit value="提交订单"></div>
		'''

	html += '''
	</form>
	</body>
	</html>
	'''
	return html

@app.route('/index', methods = ["get", "post"])
def indexGate():
	if session.get("username") is None or (request.form.get("username") != session["username"]):
		if request.form.get("username") is None:
			return "请返回登录界面进行登录！"

		username = request.form["username"]
		pwd = request.form["pwd"]
		if pwd == "":
			return "密码不能为空"
		# 是注册
		if request.values.get("register") is not None:
			nameState = checkUsername(username)
			if not nameState == "用户名未被使用":
				return nameState
			encryptedpwd = hashlib.sha256(pwd.encode('utf-8')).hexdigest()
			cursor.execute("insert into Customer values ('{0}', '{1}')".format(username, encryptedpwd))
		# 是登录
		else:
			cursor.execute("select encryptedPassword from Customer where userName = '{0}'".format(username))
			fetchedpwd = cursor.fetchall()[0][0]
			encryptedpwd = hashlib.sha256(pwd.encode('utf-8')).hexdigest()
			if fetchedpwd != encryptedpwd:
				return "密码错误"
		# 记录登录信息
		session["username"] = username
		cursor.execute("select customerID from Customer where userName = '{0}'".format(username))
		session["userid"] = cursor.fetchall()[0][0]
	else:
		username = session["username"]

	html = '''
	<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title> Online Retail </title>
		<script src="http://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
		<style type=text/css>
			.category{ border-top:5px solid black; }
			.goods{ width:1000px; height:300px; margin:50px auto; border:solid 1px gray; overflow:hidden; }
			.photo{ float:left; width:400px; height:300px; text-align:center; }
			.photo img{ display:block; width:auto; height:auto; max-width:100%; max-height:100%; margin:0 auto; }
			.intro{ float:right; width:550px; }
		</style>
	</head>
	<body>
	'''

	# 账号信息
	html += '''
		<h1> 欢迎，{0} </h1>
		<a href="/cart"> 查看购物车 </a> <br> <br>
		<a href="/order"> 查看订单 </a> <br> <br>
	'''.format(username)

	# 读取商品信息
	cursor.execute("select categoryID, productCategory from Category")
	categories = cursor.fetchall()
	for categoryID, categoryName in categories:
		html += '''
			<div class="category">
			<h1> {0} </h1>
		'''.format(categoryName)

		cursor.execute("select productID, productName, productPrice, saleAmount, stockAmount, productFigure, productDescription from Product where categoryID = {0}".format(categoryID))
		goods = cursor.fetchall()
		for idx, goodname, price, sold, stock, imageurl, description in goods:
			html += '''
					<div class="goods">
						<div class="photo"><img src="{5}"></div>
						<div class="intro">
							<h3> {1} </h3>
							<p> 价格：{2}，已售：{3}，库存：{4} </p>
							<p> {6} </p>
							数量：<input type=text id="{0}_number" size="10" maxlength="10" value="1"> 件
							<input type=submit id="{0}_add2cart" value="加入购物车">
							<br><a href="/comment?idx={0}">查看评价</a>
							<br><a href="/makeComment?idx={0}">撰写评价</a>
						</div>
					</div>
					<script type="text/javascript">
						$("#{0}_add2cart").on("click", function() {{
							var number = $("#{0}_number").val();
							$.post("/add2cart", {{idx:{0}, number:number}}, function(result) {{
								alert(result);
							}});
						}});
					</script>
			'''.format(idx, goodname, price, sold, stock, imageurl, description)

		html += '''
			</div>
		'''

	html += '''
	</body>
	</html>
	'''
	return html

if __name__ == '__main__':
	app.run(debug = True)
