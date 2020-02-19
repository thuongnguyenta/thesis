from flask import Flask,render_template, flash, redirect , url_for , session ,request, logging
from flask_mysqldb import MySQL
from datetime import date
import json
# from wtforms import Form, StringField , TextAreaField ,PasswordField , validators
# from passlib.hash import sha256_crypt
# from functools import wraps


app = Flask(__name__)
app.debug = True

app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'

app.config['MYSQL_HOST'] = '127.0.0.1'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'thesis'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
mysql = MySQL(app)

@app.route('/')
def dashboard():
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM shoes,shoes_sale,shoes_color WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes_color.id_shoes=shoes.id_shoes GROUP BY shoes.id_shoes")
    rows = cur.fetchall()
    cur.execute("SELECT * FROM shoes,shoes_color WHERE shoes.id_shoes=shoes_color.id_shoes")
    rows2 =cur.fetchall()
    return render_template('index.html',shoes=rows,shoes_color=rows2)


@app.route("/shoes/<id>")
def detail_shoes(id):
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM shoes s,shoes_sale s1,shoes_size s2,shoes_color s3 WHERE s.id_shoes=s1.id_shoes AND s.id_shoes=s2.id_shoes AND s.id_shoes=s3.id_shoes AND s.id_shoes=%s ",[id])
    rows = cur.fetchall()
    return render_template('shoes_detail.html',shoes_of_id=rows)


@app.route("/shoes/shoes_for_gender/<type>")
def shoes_for_gender(type):
    if type=="1" : gender="Giày Nam"
    elif type=="2" : gender="Giày Nữ"
    else : gender="Giày Đôi"
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM shoes,shoes_sale,shoes_color WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes_color.id_shoes=shoes.id_shoes AND shoes.shoes_for_gender=%s  GROUP BY shoes.id_shoes",[gender])
    rows = cur.fetchall()
    cur.execute("SELECT * FROM shoes,shoes_color WHERE shoes.id_shoes=shoes_color.id_shoes")
    rows2 =cur.fetchall()
    return render_template('index.html',shoes=rows,shoes_color=rows2)

@app.route("/shoes/shoe_filter",methods= ['GET','POST'])
def filter_shoes():
    if request.method == 'POST':
        if request.form['range_price']:
        # shoes_size = request.form['range_size']
            shoes_price =request.form['range_price']
            if shoes_price !="all":
        
        # if shoes_price=="all":

        #     cur=mysql.connection.cursor()
        #     cur.execute("SELECT * FROM shoes,shoes_sale WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes.shoes_for_gender=%s",[gender])
        #     rows = cur.fetchall()
        #     return render_template('index.html',shoes=rows)
        # else :
                min_price=(int(shoes_price)-100)*1000
                max_price=(int(shoes_price)+100)*1000
                print(min_price,max_price)
                cur=mysql.connection.cursor()
                cur.execute("SELECT * FROM shoes,shoes_sale,shoes_color WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes.id_shoes=shoes_color.id_shoes AND shoes.shoes_cost*(1-shoes_sale.shoes_sale_percent/100) <= %s AND shoes.shoes_cost*(1-shoes_sale.shoes_sale_percent/100) >= %s GROUP BY shoes.id_shoes",[max_price,min_price])
                rows=cur.fetchall()
                ####
                cur.execute("SELECT * FROM shoes,shoes_color WHERE shoes.id_shoes=shoes_color.id_shoes")
                rows2 =cur.fetchall()
                return render_template('index.html',shoes=rows,shoes_color=rows2)
                ###
            
        return redirect(url_for('dashboard'))
    return redirect(url_for('dashboard'))

@app.route("/search",methods=['GET','POST'])
def search():
    search_title=None
    if request.method == 'POST':
        search=request.form['search']
        string = "%"+search+"%"
        cur=mysql.connection.cursor()
        cur.execute("SELECT * FROM shoes,shoes_sale,shoes_color WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes.shoes_name LIKE %s AND shoes_color.id_shoes=shoes.id_shoes GROUP BY shoes.id_shoes",[string])
        rows=cur.fetchall()
        cur.execute("SELECT * FROM shoes,shoes_color WHERE shoes.id_shoes=shoes_color.id_shoes")
        rows2 =cur.fetchall()
        return render_template('index.html',shoes=rows,shoes_color=rows2,search_title=search)
    return redirect(url_for('dashboard'))


@app.route("/cart_detail/delete/<id_cart_detail>")
def delete_cart_detail(id_cart_detail):
    cur=mysql.connection.cursor()
    cur.execute("SELECT id_cart FROM cart_detail WHERE id_cart_detail")
    rows=cur.fetchall()
    id_cart=rows[0]['id_cart']
    cur.execute("DELETE FROM cart_detail WHERE id_cart_detail=%s",[id_cart_detail])
    mysql.connection.commit()
    update_cart(id_cart)
    
    return redirect(url_for("show_cart",id=session['id']))

def update_cart(id_cart):
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM cart_detail WHERE id_cart=%s",[id_cart])
    temp2= cur.fetchall()
    total_price=0
    total_sp=0
    for item in temp2:
        total_price+=item['sub_price']*item['number_of_shoes']
        total_sp+=item['number_of_shoes']
    cur.execute("UPDATE cart SET cart_quantity=%s,cart_total=%s WHERE id_cart=%s",[total_sp,total_price,id_cart])
    mysql.connection.commit()

@app.route("/cart/payment/<id_cart>")
def order(id_cart):
    # thêm vào order
    if 'id' in session:
        cur=mysql.connection.cursor()
        cur.execute("SELECT * FROM cart WHERE id_cart=%s",[id_cart])
        temp2= cur.fetchall()
        id_user= session['id']
        order_quantity=temp2[0]['cart_quantity']
        total_cost=temp2[0]['cart_total']
        timer_order =date.today()
        order_status="Chưa Thanh Toán"
        uname=session['name']
        cur.execute("INSERT INTO `order` (id_order,id_user,uname,order_quantity,total_cost,time_order,order_status) VALUES(%s,%s,%s,%s,%s,%s,%s)",["NULL",id_user,uname,order_quantity,total_cost,timer_order,order_status])
        
        # tìm kiếm id_order để sử dụng
        cur.execute("SELECT * FROM `order` WHERE id_user=%s ORDER BY id_order DESC limit 1 ",[id_user])
        order=cur.fetchall()
        id_order=order[0]['id_order']

        # với từng cart_detail thêm tương ứng vào order_detail
        cur.execute("SELECT * FROM cart_detail WHERE id_cart=%s",[id_cart])
        order_detail=cur.fetchall()
        mysql.connection.commit()
        for ord in order_detail:
            id_shoes=ord['id_shoes']
            shoes_name =ord['shoes_name']
            size=ord['size']
            color=ord['color']
            quantity=ord['number_of_shoes']
            sub_price=ord['sub_price']
            id_cart_detail=ord['id_cart_detail']
            cur.execute("INSERT INTO order_detail(id_order_detail,id_order,id_shoes,shoes_name,size,color,quantity,sub_price) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",["NULL",id_order,id_shoes,shoes_name,size,color,quantity,sub_price])
            mysql.connection.commit()
            cur.execute("DELETE FROM cart_detail WHERE id_cart_detail=%s",[id_cart_detail])
            mysql.connection.commit()
        cur.execute("DELETE FROM cart WHERE id_cart=%s",[id_cart])
        mysql.connection.commit()
        return redirect(url_for('person_purchase_history'))
    return redirect(url_for('login'))
    
@app.route("/person/history_purchase/")
def person_purchase_history():
    if "id" in session:
        id_user=session['id']
        cur=mysql.connection.cursor()
        cur.execute("SELECT * FROM `order` WHERE id_user=%s",[id_user])
        rows=cur.fetchall()
        cur.execute("SELECT * FROM `order`,order_detail WHERE `order`.id_order=order_detail.id_order AND id_user =%s",[id_user] )
        rows2=cur.fetchall()
        return render_template('history_order.html',orders=rows,details=rows2)
    return redirect(url_for('login'))

@app.route("/cart/<id>")
def show_cart(id):
    cur=mysql.connection.cursor()
    cur.execute("SELECT * FROM cart,cart_detail WHERE cart.id_cart=cart_detail.id_cart AND cart.id_user=%s",[id])
    rows = cur.fetchall()
    # cur.execute("SELECT SUM() FROM cart,cart_detail WHERE cart.id_cart=cart_detail.id_cart AND cart.id_cart=%s",[id])
    return render_template('cart_detail.html',shoes=rows)

@app.route("/cart/insert/<id_shoes>" ,methods= ['GET','POST'])
def cart_insert(id_shoes):
    if "id" in session:
        if request.method == 'POST':
            id=session['id']
            size = request.form['size']
            color = request.form['color']
            number= request.form['number']
            cur=mysql.connection.cursor()
            cur.execute("SELECT id_cart FROM cart WHERE id_user=%s",[id])
            rows = cur.fetchall()

            # tính các giá trị của sản phẩm giày

            cur.execute("SELECT shoes_name,shoes_cost,shoes_sale_percent FROM shoes,shoes_sale WHERE shoes.id_shoes=shoes_sale.id_shoes AND shoes.id_shoes=%s",[id_shoes])
            cost = cur.fetchall()
            price = round(cost[0]['shoes_cost']* (1-cost[0]['shoes_sale_percent']/100))
            name = cost[0]['shoes_name']
            ###
            if len(rows)==0:
                print("aaaaaaaaaaaa")
                
                # cur.execute("SELECT shoes_name,shoes_cost,shoes_sale_percent FROM shoes,shoes_sale WHERE shoes.id_shoes=shoes_sale.id_shoes AND id_shoes=%s",[id_shoes])
                # cost = cur.fetchall()
                # price = round(cost[0]['shoes_cost']* (1-cost[0]['shoes_sale_percent'/100]))
                # name = cost[0]['shoes_name']

                # tạo cart để có thể thâm cart_detail
                cur.execute("INSERT INTO cart(id_cart,id_user,cart_quantity,cart_total) VALUES(%s,%s,%s,%s)",["NULL",id,"1",price])
                mysql.connection.commit()
                # cur.execute("SELECT id_card FROM cart WHERE id_user = %s",[id])
                # temp = cur.fetchall()
                # id_cart =temp[0]['id_cart']
                # cur.execute("INSERT INTO cart_detail(id_cart_detail,id_cart,id_shoes,shoes_name,size,color,number_of_shoes,sub_price) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",["NULL",id_cart,id_shoes,name,size,color,number,price])
                # mysql.connection.commit()
                # return redirect(url_for("show_cart",id=id))
            # thêm vào cart_detail sản phẩm
            cur.execute("SELECT id_cart FROM cart WHERE id_user = %s",[id])
            temp = cur.fetchall()
            id_cart =temp[0]['id_cart']
            cur.execute("INSERT INTO cart_detail(id_cart_detail,id_cart,id_shoes,shoes_name,size,color,number_of_shoes,sub_price) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)",["NULL",id_cart,id_shoes,name,size,color,number,price])
            mysql.connection.commit()
            # update cart
            cur.execute("SELECT * FROM `cart_detail` WHERE id_cart=%s",[id_cart])
            temp2= cur.fetchall()
            total_price=0
            total_sp=0
            for item in temp2:
                total_price+=item['sub_price']*item['number_of_shoes']
                total_sp+=item['number_of_shoes']
            cur.execute("UPDATE cart SET cart_quantity=%s,cart_total=%s WHERE id_cart=%s",[total_sp,total_price,id_cart])
            mysql.connection.commit()
            return redirect(url_for("show_cart",id=id))
    return redirect(url_for('login'))
        




        # return redirect(url_for("show_cart",id=id))
@app.route("/person_infor")
def person_infor():
    if 'id' in session:
        id_user=session['id']
        cur =mysql.connection.cursor()
        cur.execute("SELECT * FROM user WHERE id_user=%s",[id_user])
        rows = cur.fetchall()
        return render_template('personal_infor.html',persons=rows)
    return redirect(url_for('login'))
@app.route("/personal/update", methods=['POST','GET'])
def update_per_infor():
    if 'id' in session:
        if request.method == 'POST':
            uname=request.form['uname']
            phone_number = request.form['phone_number']
            address = request.form['address']
            id_user=session['id']
            cur =mysql.connection.cursor()
            cur.execute("UPDATE user SET uname = %s,user_phone_number = %s ,address = %s WHERE id_user = %s",(uname,phone_number,address,id_user))
            mysql.connection.commit()
            session['name']=uname
            return redirect(url_for('person_infor'))
    return redirect(url_for('login'))

@app.route("/personal/changepass" ,methods=['GET','POST'])
def change_ps():
    error=None
    if 'id' in session:
        if request.method == 'POST':
            curpass=request.form['current_pw']
            newpass=request.form['new_pw']
            cf_newpass=request.form['cf_new_pw']
            id_user=session['id']
            cur =mysql.connection.cursor()
            cur.execute("SELECT * FROM user WHERE id_user=%s",[id_user])
            rows1 = cur.fetchall()
            if newpass!=cf_newpass :
                return render_template('personal_infor.html',persons=rows1 ,error="Không trùng khớp")
            cur =mysql.connection.cursor()
            cur.execute("SELECT * FROM user WHERE id_user=%s",([session['id']]))
            rows = cur.fetchall()
            if curpass !=rows[0]['password'] :
                return render_template('personal_infor.html',persons=rows1,error="Mật khẩu không chính xác")
            else :
                cur.execute("UPDATE user SET password =%s WHERE id_user =%s",[newpass,session['id']])
                mysql.connection.commit()
                return render_template('personal_infor.html',persons=rows1,error=error)
            
        return redirect(url_for('dashboard'))
        
    return redirect(url_for('login'))

@app.route("/login" ,methods= ['GET','POST'])
def login():
    if 'id' in session:
        return redirect(url_for('dashboard'))
    error=None
    if request.method == 'POST':
        
        email=request.form['tk']
            # username=request.form['username']
        password =request.form['mk']
        cur =mysql.connection.cursor()
        cur.execute("SELECT * FROM user WHERE user_uname=%s and password=%s",(email,password))
        rows = cur.fetchall()
        if len(rows) ==0:
            error="Sai tai khoan hoac mat khau"
            return render_template('login.html',error=error)
        else:
            session['id'] = rows[0]['id_user']
            session['name'] = rows[0]['uname']
            session["mail"] =rows[0]['user_uname']
            return redirect(url_for('dashboard'))
            # return "Login success !"
    return render_template('login.html')

# def login_required():
#     if 
@app.route('/logout')
def logout():
    session.clear()
    # session.pop('id',None)
    # session.pop('role',None)
    return redirect(url_for('dashboard'))










if __name__ == '__main__':
    # app.secret_key='secret134'
    app.run()
