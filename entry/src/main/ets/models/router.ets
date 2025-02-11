import { ExceptionList } from "."

export class CommonRouterParams {
  id?: string = ''
  oldTime?: string = ''
  address?: string = ''
  addException?: boolean = false
  exceptionDetail?: ExceptionList | null = null
}