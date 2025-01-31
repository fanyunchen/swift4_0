// 封装网络请求的工具
import { BASE_URL, TOKEN_KEY } from "../constants";
import { http } from "@kit.NetworkKit";

/**
 * 实现网络请求的方法
 */
export function requestTHttp(
  url:string,
  method:http.RequestMethod = http.RequestMethod.GET,
  data?:object
){
  let urlStr = BASE_URL + url // 请求的地址

  // get请求传参处理
  if (method === http.RequestMethod.GET) {
    // 判断是否需要携带数据
    if (data && Object.keys(data).length) {
      // 需要携带数据
      urlStr += "?" + Object.keys(data).map((key)=>{
        // 判断该属性是否有值
        if (data[key]) {
          // 有值
          return `${key}=${data[key]}`
        }
        // 没值
        return ''
      }).join("&")
    }
  }
  
  // 1.创建请求
  const httpRequest = http.createHttp()

  // 2.设置请求头
  const config:http.HttpRequestOptions = {
    header:{
      "Content-Type":"application/json",  // 请求数据类型
      "Authorization":AppStorage.get<string>(TOKEN_KEY) || ''  // 获取用户令牌，用户登录成功后存储在PersistentStorage
    },
    method:method,
    extraData:method === http.RequestMethod.GET ? "" : data // get请求参数应在地址栏中
  }

  httpRequest.request(urlStr,config)


}