export * from "./advert"

export * from './user'

// 服务器端所有接口返回的数据类型
export class ResponseData<T>{
  code:number = 0
  msg:string = ''
  data: T | null = null
}