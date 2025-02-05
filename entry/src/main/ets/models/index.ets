export * from "./advert"

export * from './user'

export * from "./tab"

export * from "./task"

export * from "./router"

// 服务器端所有接口返回的数据类型
export class ResponseData<T> {
  code: number = 0
  msg: string = ''
  data: T | null = null
}