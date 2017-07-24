
SDKDemo：
1.new一个static/framework工程 同时add到demo工程里
2.demo工程添加link库为sdk工程的target
3.资源问题，sdk工程添加bundle 【1.在base中修改为iOS 2.如果是动态framework需要在sdk工程的build phase添加资源依赖】
4.拖到三方工程使用时，如果是动态framework需要配置在embeded binaries中【不然找不到镜像】（疑问：sdk工程以嵌入子工程在demo工程）