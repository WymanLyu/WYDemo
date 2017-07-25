
SDKDemo：
1.new一个static/framework工程 同时add到demo工程里
2.demo工程添加link库为sdk工程的target
3.资源问题，sdk工程添加bundle 【1.在base中修改为iOS 2.如果是动态framework需要在sdk工程的build phase添加资源依赖】路径：
	.app [sdkDemo工程的main bundle]
	   - frameworks [仅仅是framwork的动态库才被embeded在此所以可以加载bundle，静态库此处是nil]
		- bundle
demo工程/主工程加载资源
	NSBundle *bundle= [NSBundle bundleForClass:<#framework_class#>];
该方法会在framework查找对应class同级别的bundle【动态库framework】
假设是静态库都没有，此处会返回mainbundle，所以静态库需要将bundle拷入主工程。。

4.拖到三方工程使用时，如果是动态framework需要配置在embeded binaries中【不然找不到镜像】（疑问：sdk工程以嵌入子工程在demo工程中并没有配置，实际上pods是在主工程中执行Build Phase -> Embed Pods Frameworks脚本加入）