
workspace下可以添加工程 A工程依赖B工程的product【可以用静态库方式 Link Binary】 ==》 如果有分类：则B工程里面在linker flag 标识link时加载“-ObjC” 或者生成库里有类实现。。