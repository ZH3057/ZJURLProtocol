# ZJURLProtocol

基于`NSURLProtocol`, `AFNetworking` 进行请求拦截 返回mock数据

 
导入即可使用, 默认DEBUG模式开启
 
 json文件即为mock数据 格式填写 "urlPath" : "data" DEBUG模式下 不需要进行mock 删除json内容即可
 
 ```json
 
 {
    "/***/****/path" : {
        "code": 99999,
        "data": {
            ....
        },
        "msg": "成功测试数据"
    }
}
 
 ```