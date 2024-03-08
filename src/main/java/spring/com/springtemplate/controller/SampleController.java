package spring.com.springtemplate.controller;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import spring.com.springtemplate.vo.Result;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/
@Slf4j
@RestController
@RequestMapping("/ql")
public class SampleController {
    @GetMapping("/test")
    public Result<?> getName(){
        return Result.ok("this is my first api");
    }
}
