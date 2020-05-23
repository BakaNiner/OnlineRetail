from flask import Flask, request, session
import pymssql
import hashlib

app = Flask(__name__)
app.config['SECRET_KEY'] = "secret_key"

def checkUsername(username):
	if username is "":
		return "用户名不能为空"
	if not username.isalnum():
		return "含有非法字符，请使用数字和字母"
	# 这边要改成sql
	if username in ["aaa", "bbb"]:
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
			if(state != "用户名未被使用") {
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

@app.route('/add2cart', methods = ["post"])
def add2cartGate():
	idx = request.form["idx"]
	number = request.form["number"]
	if not number.isdigit():
		return "添加购物车失败！请检查数量是否正确"
	return "添加购物车成功"

@app.route('/comment', methods = ["get"])
def commentGate():
	idx = request.args["idx"]
	if not idx.isdigit():
		return "错误商品id"

	# 这边要改成sql
	goodname = "商品名"
	comments = [(10086, 5, "很好！", "2020-5-24"), (30009, 2, "不行！", "2020-2-31")]

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
		for userid, rate, comment, time in comments:
			# 这边可能要改成username
			html += '''
				<div class="comment">
				<h3> 用户{0}***{1} </h3>
			'''.format(str(userid)[0], str(userid)[-1])
			html += "<p>" + "★" * rate + "☆" * (5 - rate) + " " + time + "</p>"
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
	idx = request.form["idx"]
	text = request.form["text"]
	rate = request.form["rate"]
	if text == "":
		return "评价不能为空"
	return "发表评论成功"

@app.route('/makeComment', methods = ["get"])
def makeCommentGate():
	idx = request.args["idx"]
	if not idx.isdigit():
		return "错误商品id"

	# 这边要改成sql
	goodname = "商品名"

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

@app.route('/removeCart', methods = ["post"])
def removeCartGate():
	idx = request.form["idx"]
	return "移出成功"

@app.route('/createOrder', methods = ["post"])
def createOrder():
	# TBD
	cart = [(10001, "PONY电视", 29000, 1), (10003, "Switch", 2300, 2)]
	return "None"

@app.route('/cart', methods = ["get"])
def cartGate():
	username = session.get("username")
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

	# 这边要改成sql
	cart = [(10001, "PONY电视", 29000, 9998, "static/images/10001.jpg", 1), (10003, "Switch", 2300, 10000, "static/images/10003.jpg", 2)]

	# 读取购物车
	for idx, goodname, price, stock, image, number in cart:
		html += '''
			<div class="goods">
				<div class="photo"><img src="{4}"></div>
				<div class="intro">
					<h3> {1} </h3>
					<p> 价格：{2}，库存：{3} </p>
					<p> 购买：{5}件 </p>
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
		'''.format(idx, goodname, price, stock, image, number)

	html += '''
	<div align="center"><input type=submit value="提交订单"></div>
	</form>
	</body>
	</html>
	'''
	return html

@app.route('/index', methods = ["post"])
def indexGate():
	name = request.form["username"]
	# 这边要改成sql
	# 是注册
	if request.values.get("register") is not None:
		nameState = checkUsername(name)
		if not nameState == "用户名未被使用":
			return nameState
	# 是登录
	else:
		pass
	session["username"] = name

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
	'''.format(name)

	# 读取商品信息
	categories = ["电器", "服装"]
	for i in range(len(categories)):
		html += '''
			<div class="category">
			<h1> {0} </h1>
		'''.format(categories[i])

		# 这边用sql语句换掉
		if categories[i] == "电器":
			goods = [(10001, "PONY电视", 29000, 233, 9998, "static/images/10001.jpg", "这里是备注"), (10003, "Switch", 2300, 100, 10000, "static/images/10003.jpg", "这里是备注")]
		elif categories[i] == "服装":
			goods = [(10002, "小裙子", 1000, 500, 99999, "static/images/10002.jpg", "这里是备注")]
		else:
			goods = []

		for idx, name, price, sold, stock, imageurl, remark in goods:
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
			'''.format(idx, name, price, sold, stock, imageurl, remark)

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
