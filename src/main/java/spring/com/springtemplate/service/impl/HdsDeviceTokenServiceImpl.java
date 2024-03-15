package spring.com.springtemplate.service.impl;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import spring.com.springtemplate.mapper.HdsDeviceTokenMapper;
import spring.com.springtemplate.pojo.entity.HdsDeviceTokenEntity;
import spring.com.springtemplate.service.HdsDeiceTokenService;
/**
 * @Author qiang.long
 * @Date 2024/03/15
 * @Description
 **/
@Service
public class HdsDeviceTokenServiceImpl extends ServiceImpl<HdsDeviceTokenMapper, HdsDeviceTokenEntity> implements HdsDeiceTokenService {

}
