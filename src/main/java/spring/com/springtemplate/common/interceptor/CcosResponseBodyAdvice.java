package spring.com.springtemplate.common.interceptor;
import com.alibaba.druid.support.json.JSONUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;
import spring.com.springtemplate.pojo.exception.BusinessException;
import spring.com.springtemplate.vo.Result;
/**
 * @Author qiang.long
 * @Date 2024/03/15
 * @Description 异常处理器
 **/

@Slf4j
@RestControllerAdvice
public class CcosResponseBodyAdvice implements ResponseBodyAdvice<Object>, WebMvcConfigurer {
    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        return true;
    }
    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        if (body instanceof Result){
            return body;
        }else {
            return Result.ok(body);
        }
    }

    @ExceptionHandler({BusinessException.class})
    @ResponseStatus(HttpStatus.OK)
    public Object handleBusinessException(BusinessException e){
        Result<Object> objectResult=Result.errorResult(e.getMessage());
        log.info("business.exception:{}", JSONUtils.toJSONString(objectResult));
        return objectResult;
    }
}
