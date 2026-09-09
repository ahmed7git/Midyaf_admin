# 🚀 الدليل الشامل لملفات الباك إند وربط تطبيق الإدارة (Backend API Documentation)

هذا الدليل يشرح بالتفصيل كل شاشة في تطبيق الفلاتر (`Admin App`)، وما هو ملف الـ PHP المقابل لها على السيرفر، مسار الملف الدقيق، المتغيرات المرسلة (`POST Parameters`)، وشكل الاستجابة المتوقعة (`JSON Response`).

> **🌐 الرابط الأساسي للسيرفر (Base URL):**
> `https://wicmn.alwaysdata.net/delever`

---

## 📑 فهرس الشاشات والملفات المطلوبة

| # | الشاشة في التطبيق (Flutter Screen) | ملف الباك إند (PHP File Path) | نوع الطلب (HTTP Method) | الوظيفة |
|---|---|---|---|---|ِِ
| 1 | **تسجيل الدخول** (`Login`) | `admin/auth/login.php` | `POST` | التحقق من بيانات المدير وإرجاع الجلسة |
| 2 | **لوحة التحكم والمراقبة** (`Home Dashboard`) | `admin/home/dashboard.php` | `POST` | إحصائيات الإيرادات، الطلبات، المخزون، والرسم البياني |
| 3 | **عرض الأقسام** (`Categories`) | `admin/categories/view.php` | `POST` | جلب قائمة الأقسام والتصنيفات |
| 4 | **إضافة قسم جديد** (`AddCategory`) | `admin/categories/add.php` | `POST (Multipart)` | رفع صورة القسم وإضافة الاسم العربي والإنجليزي |
| 5 | **تعديل قسم** (`EditCategory`) | `admin/categories/edit.php` | `POST (Multipart)` | تحديث بيانات وصورة القسم |
| 6 | **حذف قسم** (`DeleteCategory`) | `admin/categories/delete.php` | `POST` | حذف القسم وصورته من السيرفر |
| 7 | **عرض المنتجات والمخزون** (`Items`) | `admin/items/view.php` | `POST` | جلب المنتجات مع كميات المخزون والأسعار |
| 8 | **إضافة منتج جديد** (`AddItem`) | `admin/items/add.php` | `POST (Multipart)` | إضافة منتج، السعر، الخصم، القسم، والمخزون |
| 9 | **تعديل منتج** (`EditItem`) | `admin/items/edit.php` | `POST (Multipart)` | تعديل تفاصيل وسعر ومخزون المنتج |
| 10 | **حذف منتج** (`DeleteItem`) | `admin/items/delete.php` | `POST` | حذف المنتج وصورته |
| 11 | **تحديث حالة/كمية المخزون** (`UpdateStock`) | `admin/items/update_stock.php` | `POST` | تعديل كمية الصنف وتفعيله/إخفائه |
| 12 | **عرض الطلبات الجارية والمكتملة** (`Orders`) | `admin/order/order.php` | `POST` | جلب كافة الطلبات لمتابعتها |
| 13 | **تفاصيل ومخطط الطلب** (`OrderDetails`) | `admin/order/orderdetils.php` | `POST` | جلب تفاصيل وجبات الطلب، العميل، والأسعار |
| 14 | **قبول وتعيين حالة الطلب** (`OrderAccept / UpdateStatus`) | `admin/not/pendind.php` أو `admin/order/update_status.php` | `POST` | تغيير حالة الطلب (0➔1➔2➔3➔4) |
| 15 | **حذف/إلغاء طلب** (`DeleteOrder`) | `admin/order/delete.php` | `POST` | حذف الطلب من النظام |
| 16 | **إدارة المستخدمين والمسؤولين** (`ViewUser`) | `admin/users/view.php` | `POST` | جلب قائمة المدراء والمستخدمين |
| 17 | **إضافة مسؤول جديد** (`AddUser`) | `admin/users/add.php` | `POST` | تسجيل مدير جديد وتحديد صلاحياته |
| 18 | **عرض مناديب التوصيل** (`ViewDrivers`) | `admin/delivery/view.php` | `POST` | جلب المناديب المتصلين ومواقعهم |
| 19 | **سجل الإشعارات** (`Notifications`) | `notification/notification.php` | `POST` | جلب الإشعارات والتنبيهات السابقة |
| 20 | **إرسال إشعار عام** (`SendNotification`) | `admin/notification/send.php` | `POST` | بث إشعار للعملاء أو المناديب عبر FCM |

---

## 🔍 التفاصيل التقنية لكل ملف (Parameters & JSON Schema)

---

### 1. شاشة تسجيل الدخول (`Login`)
* **الملف المطلوب:** `admin/auth/login.php`
* **الرابط الكامل:** `https://wicmn.alwaysdata.net/delever/admin/auth/login.php`
* **نوع الطلب:** `POST`
* **المتغيرات المطلوبة (`POST Body`):**
  ```json
  {
    "email": "admin@gmail.com",
    "password": "your_password"
  }
  ```
* **الاستجابة في حال النجاح (`Success Response`):**
  ```json
  {
    "status": "success",
    "data": {
      "admin_id": 1,
      "admin_name": "أحمد محمد",
      "admin_email": "admin@gmail.com",
      "admin_phone": "0500000000",
      "admin_role": 1,
      "admin_approve": 1,
      "admin_token": "fcm_token_here",
      "admin_created": "2026-08-30 10:00:00"
    }
  }
  ```
* **الاستجابة في حال الفشل (`Failure Response`):**
  ```json
  {
    "status": "failure",
    "message": "Email Or Password Not Correct"
  }
  ```

---

### 2. لوحة القيادة والمراقبة الشاملة (`Home Dashboard`)
* **الملف المطلوب:** `admin/home/dashboard.php`
* **الرابط الكامل:** `https://wicmn.alwaysdata.net/delever/admin/home/dashboard.php`
* **نوع الطلب:** `POST`
* **المتغيرات المطلوبة (`POST Body`):**
  ```json
  {
    "period": "week" // الخيارات: "today", "week", "month", "year"
  }
  ```
* **الاستجابة المتوقعة (`Success Response`):**
  ```json
  {
    "status": "success",
    "data": {
      "overview": {
        "total_revenue": 12450.75,
        "total_orders": 240,
        "total_users": 580,
        "active_drivers": 6,
        "avg_order_value": 51.87,
        "growth_percentage": 14.2
      },
      "order_stats": {
        "pending": 5,
        "preparing": 8,
        "ready": 3,
        "on_the_way": 7,
        "delivered": 215,
        "cancelled": 2
      },
      "stock_stats": {
        "in_stock": 120,
        "low_stock": 8,
        "out_of_stock": 2,
        "total_products": 130
      },
      "chart_data": [
        { "day_name": "السبت", "date": "2026-08-24", "amount": 1450.0, "order_count": 28 },
        { "day_name": "الأحد", "date": "2026-08-25", "amount": 1800.0, "order_count": 34 },
        { "day_name": "الإثنين", "date": "2026-08-26", "amount": 1600.5, "order_count": 31 },
        { "day_name": "الثلاثاء", "date": "2026-08-27", "amount": 2100.0, "order_count": 40 },
        { "day_name": "الأربعاء", "date": "2026-08-28", "amount": 1950.0, "order_count": 38 },
        { "day_name": "الخميس", "date": "2026-08-29", "amount": 2500.0, "order_count": 48 },
        { "day_name": "الجمعة", "date": "2026-08-30", "amount": 3050.25, "order_count": 60 }
      ],
      "top_items": [
        {
          "items_id": 12,
          "items_name": "Double Burger",
          "items_name_ar": "برجر لحم دبل",
          "items_images": "burger.png",
          "categories_name_ar": "وجبات سريعة",
          "total_sold": 95,
          "total_revenue": 2850.0
        }
      ],
      "recent_orders": [
        {
          "order_id": 105,
          "order_userid": 42,
          "order_price": 45.0,
          "order_delivery": 10.0,
          "order_totalprice": 55.0,
          "order_status": 0,
          "order_paymentmethod": 1,
          "order_type": 0,
          "order_created": "2026-08-31 07:15:00"
        }
      ]
    }
  }
  ```

---

### 3. شاشة إدارة الأقسام (`Categories`)
* **الملفات المطلوبة:**
  1. **عرض الأقسام:** `admin/categories/view.php`
  2. **إضافة قسم:** `admin/categories/add.php`
  3. **تعديل قسم:** `admin/categories/edit.php`
  4. **حذف قسم:** `admin/categories/delete.php`

#### أ. `admin/categories/view.php`
* **المتغيرات:** لا يتطلب متغيرات (POST فارغ `{}`).
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "categories_id": 1,
        "categories_name": "Burgers",
        "categories_name_ar": "برجر",
        "categories_image": "burger_cat.svg",
        "categories_active": 1,
        "categories_datatime": "2026-08-01 12:00:00"
      }
    ]
  }
  ```

#### ب. `admin/categories/add.php`
* **نوع الطلب:** `POST (Multipart)`
* **المتغيرات:**
  - `name`: اسم القسم بالإنجليزي (String)
  - `namear`: اسم القسم بالعربي (String)
  - `files['categories_image']`: ملف صورة القسم (File / SVG / PNG)
* **الاستجابة:** `{"status": "success"}`

#### ج. `admin/categories/edit.php`
* **المتغيرات:**
  - `id`: رقم القسم (`categories_id`)
  - `name`: الاسم بالإنجليزي
  - `namear`: الاسم بالعربي
  - `imageold`: اسم الصورة القديمة
  - `files['categories_image']`: الصورة الجديدة (اختياري)
* **الاستجابة:** `{"status": "success"}`

#### د. `admin/categories/delete.php`
* **المتغيرات:**
  - `categories_id`: رقم القسم
  - `categories_image`: اسم ملف الصورة لحذفها من مجلد `upload/categories/`
* **الاستجابة:** `{"status": "success"}`

---

### 4. شاشة المنتجات والمخزون (`Items & Inventory`)
* **الملفات المطلوبة:**
  1. **عرض المنتجات:** `admin/items/view.php`
  2. **إضافة منتج:** `admin/items/add.php`
  3. **تعديل منتج:** `admin/items/edit.php`
  4. **حذف منتج:** `admin/items/delete.php`
  5. **تحديث المخزون:** `admin/items/update_stock.php`

#### أ. `admin/items/view.php`
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "items_id": 10,
        "items_categories": 1,
        "items_name": "Crispy Chicken",
        "items_name_ar": "دجاج كريسبي",
        "items_desc": "Delicious crispy chicken meal",
        "items_descr_ar": "وجبة دجاج مقرمش شهية",
        "items_images": "crispy.png",
        "items_count": 25,
        "items_active": 1,
        "items_price": 35,
        "items_discount": 10,
        "items_date": "2026-08-10 14:30:00"
      }
    ]
  }
  ```

#### ب. `admin/items/add.php`
* **نوع الطلب:** `POST (Multipart)`
* **المتغيرات:**
  - `name`: الاسم بالإنجليزي
  - `namear`: الاسم بالعربي
  - `desc`: الوصف بالإنجليزي
  - `descar`: الوصف بالعربي
  - `count`: كمية المخزون (عدد القطع)
  - `price`: السعر
  - `discount`: نسبة الخصم
  - `catid`: رقم القسم التابع له (`items_categories`)
  - `files['items_images']`: ملف صورة الوجبة
* **الاستجابة:** `{"status": "success"}`

#### ج. `admin/items/edit.php`
* **المتغيرات:**
  - `id`: معرف الصنف (`items_id`)
  - `name`, `namear`, `desc`, `descar`, `count`, `price`, `discount`, `catid`, `active`
  - `imageold`: اسم الصورة القديمة
  - `files['items_images']`: الصورة الجديدة إن وجدت
* **الاستجابة:** `{"status": "success"}`

#### د. `admin/items/update_stock.php` (تحديث المخزون السريع)
* **المتغيرات:**
  - `itemid`: رقم المنتج
  - `count`: الكمية الجديدة
  - `active`: 1 لتفعيل العرض، 0 للإخفاء
* **الاستجابة:** `{"status": "success"}`

---

### 5. شاشة متابعة وتفاصيل الطلبات (`Orders & Flowchart`)
* **الملفات المطلوبة:**
  1. **قائمة كافة الطلبات:** `admin/order/order.php`
  2. **تفاصيل أصناف الطلب:** `admin/order/orderdetils.php`
  3. **قبول/تحديث مسار الطلب:** `admin/not/pendind.php` أو `admin/order/update_status.php`
  4. **حذف طلب:** `admin/order/delete.php`

#### أ. `admin/order/order.php`
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "order_id": 101,
        "order_userid": 15,
        "order_address": 3,
        "order_type": 0,            // 0: توصيل, 1: استلام من الفرع
        "order_pricedelivery": 10,
        "order_price": 75,
        "order_coupon": 0,
        "order_totalprice": 85,
        "order_paymentmethod": 1,   // 0: كاش, 1: بطاقة/دفع إلكتروني
        "order_status": 0,          // 0: بانتظار الموافقة, 1: تحضير, 2: جاهز, 3: مع المندوب, 4: تم التسليم
        "order_created": "2026-08-31 06:40:00"
      }
    ]
  }
  ```

#### ب. `admin/order/orderdetils.php`
* **المتغيرات:**
  - `orderid`: رقم الطلب
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "order_id": 101,
        "order_status": 1,
        "order_price": 75,
        "order_delivery": 10,
        "order_totalprice": 85,
        "coupon_discount": 0,
        "address_lat": 24.7136,
        "address_long": 46.6753,
        "items_id": 10,
        "items_name": "Crispy Chicken",
        "items_name_ar": "دجاج كريسبي",
        "items_price": 35,
        "items_images": "crispy.png",
        "cart_count": 2
      }
    ]
  }
  ```

#### ج. `admin/not/pendind.php` (قبول الطلب وتغيير حالته إلى قيد التحضير)
* **المتغيرات:**
  - `orderid`: رقم الطلب
  - `usersid`: رقم العميل (لإرسال إشعار FCM فوري له)
  - `adminid`: رقم المسؤول الذي وافق على الطلب
* **الاستجابة:** `{"status": "success"}`

---

### 6. شاشة المستخدمين والمدراء (`Users & Admin Staff`)
* **الملفات المطلوبة:**
  1. **عرض المستخدمين:** `admin/users/view.php`
  2. **إضافة مستخدم/مسؤول:** `admin/users/add.php`

#### أ. `admin/users/view.php`
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "admin_id": 1,
        "admin_name": "أحمد المدير",
        "admin_email": "admin@system.com",
        "admin_phone": "0555123456",
        "admin_role": 1,
        "admin_status": 1,
        "admin_image": "avatar.png",
        "admin_created": "2026-08-01 10:00:00"
      }
    ]
  }
  ```

#### ب. `admin/users/add.php`
* **المتغيرات:**
  - `name`: اسم المسؤول
  - `email`: البريد الإلكتروني
  - `phone`: رقم الجوال
  - `password`: كلمة المرور (مشفرة بـ sha1)
* **الاستجابة:** `{"status": "success"}`

---

### 7. شاشة سجل الإشعارات (`Notifications`)
* **الملف المطلوب:** `notification/notification.php`
* **الاستجابة:**
  ```json
  {
    "status": "success",
    "data": [
      {
        "notification_id": 1,
        "notification_title": "طلب جديد #101",
        "notification_body": "قام العميل بإنشاء طلب جديد، يرجى الموافقة عليه",
        "notification_userid": 1,
        "notification_created": "2026-08-31 07:00:00"
      }
    ]
  }
  ```

---

## 🗄️ جداول قاعدة البيانات المقترحة (Database Schema)

إذا كنت تنشئ قاعدة البيانات من الصفر أو تعدلها، إليك بنية الجداول المتوافقة تماماً:

```sql
-- 1. جدول مدراء ومسؤولي النظام
CREATE TABLE `admin` (
  `admin_id` INT AUTO_INCREMENT PRIMARY KEY,
  `admin_name` VARCHAR(150) NOT NULL,
  `admin_email` VARCHAR(150) UNIQUE NOT NULL,
  `admin_phone` VARCHAR(30) NOT NULL,
  `admin_password` VARCHAR(255) NOT NULL,
  `admin_role` INT DEFAULT 1,
  `admin_status` INT DEFAULT 1,
  `admin_approve` INT DEFAULT 1,
  `admin_token` VARCHAR(255) NULL,
  `admin_created` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. جدول الأقسام
CREATE TABLE `categories` (
  `categories_id` INT AUTO_INCREMENT PRIMARY KEY,
  `categories_name` VARCHAR(150) NOT NULL,
  `categories_name_ar` VARCHAR(150) NOT NULL,
  `categories_image` VARCHAR(255) NOT NULL,
  `categories_active` INT DEFAULT 1,
  `categories_datatime` DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. جدول المنتجات والمخزون
CREATE TABLE `items` (
  `items_id` INT AUTO_INCREMENT PRIMARY KEY,
  `items_categories` INT NOT NULL,
  `items_name` VARCHAR(150) NOT NULL,
  `items_name_ar` VARCHAR(150) NOT NULL,
  `items_desc` TEXT NULL,
  `items_descr_ar` TEXT NULL,
  `items_images` VARCHAR(255) NOT NULL,
  `items_count` INT DEFAULT 0,
  `items_active` INT DEFAULT 1,
  `items_price` DECIMAL(10,2) NOT NULL,
  `items_discount` INT DEFAULT 0,
  `items_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`items_categories`) REFERENCES `categories`(`categories_id`) ON DELETE CASCADE
);

-- 4. جدول الطلبات
CREATE TABLE `orders` (
  `order_id` INT AUTO_INCREMENT PRIMARY KEY,
  `order_userid` INT NOT NULL,
  `order_address` INT NULL,
  `order_type` INT DEFAULT 0,
  `order_pricedelivery` DECIMAL(10,2) DEFAULT 0.00,
  `order_price` DECIMAL(10,2) NOT NULL,
  `order_coupon` INT DEFAULT 0,
  `order_totalprice` DECIMAL(10,2) NOT NULL,
  `order_paymentmethod` INT DEFAULT 0,
  `order_status` INT DEFAULT 0,
  `order_created` DATETIME DEFAULT CURRENT_TIMESTAMP
);
```
