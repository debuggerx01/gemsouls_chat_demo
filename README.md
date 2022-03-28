# Gemsouls chat demo


## 在线DEMO
[http://www.debuggerx.com/flutter_chat_demo/](http://www.debuggerx.com/flutter_chat_demo/)


## 操作说明
### Fake Login 界面
1. 可以通过点击右下角的`Add user`按钮增加用户，用户名和头像都将随机生成
2. 点击用户头像，即选择以该用户身份登录，并转跳至`Contacts`界面

### Contacts 界面
1. 可以通过点击右下角的`Logout`按钮返回用户选择页面
2. 点击聊天记录，进入`Chatting`页面

> 1. 本页面将默认显示除当前用户外，所有在`Fake Login`界面创建的用户
    2. 列表将以最后一次消息发生的时间次序排序显示

### Chatting 界面
1. 在底部输入框中输入想要发送的文字，点右下角的发送按钮发送消息并清空输入框
2. 点击左下角的图片按钮，随机发送一个图片消息
3. 发送消息后，一秒后对方将回复一条相同的信息作为 Echo
3. 可以点击消息旁的👍图标，对对方发出的消息进行点赞和取消点赞操作

> 可以利用`Fake Login`界面切换登录用户，查看别的用户给自己消息的点赞效果


## 说明
1. 由于使用了[hive](https://github.com/hivedb/hive)作为本地存储引擎，故源码运行前需要先进行代码生成（二选一）：
    1. 手动执行`flutter pub run build_runner build`
    2. 运行 `source_gen.sh` 脚本
    
2. 理论上本源码可以运行于所有flutter支持的平台（Android、iOS、Linux、MacOS、web、Windows），但项目中目前只加入了Android、Linux和web的模板。如需编译其他平台，需要先增加对应平台的模板文件，以iOS平台举例，需要在项目根目录下执行：`flutter create --platform ios .`
