// 封装网络请求的工具
import { BASE_URL, TOKEN_KEY } from "../constants";
import { http } from "@kit.NetworkKit";
import promptAction from "@ohos.promptAction";
import { UserSettingClass } from ".";
import { ResponseData } from "../models";

/**
 * 实现网络请求的方法
 */
export async function requestTHttp<T>(
  url: string,
  method: http.RequestMethod = http.RequestMethod.GET,
  data?: object
) {
  let urlStr = BASE_URL + url // 请求的地址

  // get请求传参处理
  if (method === http.RequestMethod.GET) {
    // 判断是否需要携带数据
    if (data && Object.keys(data).length) {
      // 需要携带数据
      urlStr += "?" + Object.keys(data).map((key) => {
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
  const config: http.HttpRequestOptions = {
    header: {
      "Content-Type": "application/json", // 请求数据类型
      "Authorization": AppStorage.get<string>(TOKEN_KEY) || ''  // 获取用户令牌，用户登录成功后存储在PersistentStorage
    },
    method: method,
    extraData: method === http.RequestMethod.GET ? "" : data // get请求参数应在地址栏中
  }

  try {
    // 3.发送请求
    const res = await httpRequest.request(urlStr, config)
    // 4.解析结果
    if (res.responseCode === 401) {
      promptAction.showToast({ message: '未授权或token失效' })
      console.log('hmlog-->', '未授权或token失效')
      AppStorage.set(TOKEN_KEY, '') // 清空本地缓存中的token
      new UserSettingClass(getContext()).setUserToken('') // 清空首选项中token
      return ''
    } else if (res.responseCode === 404) {
      // 地址错误或找不到资源地址
      promptAction.showToast({ message: '请求地址错误' })
      console.log('hmlog-->', '请求地址错误')
      return ''
    } else {
      // 请求成功
      const result = JSON.parse(res.result.toString()) as ResponseData<T>
      if (result.code === 200) {
        // 执行成功
        console.log('hmlog-->', "result.data:" + result.data)
        return result.data
      } else {
        promptAction.showToast({ message: result.msg })
        console.log('hmlog-->', 'result.msg:' + result.msg)
        return ''
      }
    }
  } catch (err) {
    promptAction.showToast({ message: JSON.stringify(err) })
    console.error('hmlog-->', "requestTHttp Failed.Err:" + JSON.stringify(err))
    return ''
  } finally {
    // 关闭请求
    httpRequest.destroy()
  }
}

export class Request {
  static get<T>(url: string, data?: object): Promise<"" | T | null> {
    return requestTHttp<T>(url, http.RequestMethod.GET, data)
  }

  static post<T>(url: string, data?: object): Promise<"" | T | null> {
    return requestTHttp<T>(url, http.RequestMethod.POST, data)
  }

  static delete<T>(url: string, data?: object): Promise<"" | T | null> {
    return requestTHttp<T>(url, http.RequestMethod.DELETE, data)
  }

  static put<T>(url: string, data?: object): Promise<"" | T | null> {
    return requestTHttp<T>(url, http.RequestMethod.PUT, data)
  }
}