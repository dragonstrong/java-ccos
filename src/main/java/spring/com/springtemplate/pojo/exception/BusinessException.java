package spring.com.springtemplate.pojo.exception;
import spring.com.springtemplate.enums.ErrorCode;
/**
 * @Author qiang.long
 * @Date 2024/03/14
 * @Description
 **/

public class BusinessException extends RuntimeException{
    private Integer code=Integer.valueOf(-1);
    public BusinessException() {
    }
    public BusinessException(Throwable throwable){
        super(throwable);
    }
    public BusinessException(String message,Throwable throwable){
        super(message,throwable);
    }
    public BusinessException(String message) {
        super(message);
    }

    public BusinessException(ErrorCode errorCode,Object... param){
        super(String.format(errorCode.getMsg(),param));
        this.code=errorCode.getCode();
    }
    public BusinessException(int code,String message, Object... param){
        super(String.format(message,param));
        this.code=Integer.valueOf(code);
    }
    public Integer getCode(){
        return code;
    }
    public BusinessException setCode(Integer code){
        this.code=code;
        return this;
    }

}
