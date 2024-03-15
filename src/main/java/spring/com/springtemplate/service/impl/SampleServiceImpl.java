package spring.com.springtemplate.service.impl;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import spring.com.springtemplate.pojo.entity.HdsDeviceTokenEntity;
import spring.com.springtemplate.pojo.exception.BusinessException;
import spring.com.springtemplate.service.SampleService;
import spring.com.springtemplate.vo.Result;

import javax.annotation.Resource;
import java.util.Optional;
/**
 * @Author qiang.long
 * @Date 2024/03/07
 * @Description
 **/

@Slf4j
@Service
public class SampleServiceImpl implements SampleService {
    @Resource
    private HdsDeviceTokenServiceImpl hdsDeviceTokenServiceImpl;
    @Override
    public Result<String> getToken(String deviceSn){
        HdsDeviceTokenEntity hdsDeviceTokenEntity= Optional.ofNullable(hdsDeviceTokenServiceImpl.getBaseMapper().selectList(new QueryWrapper<HdsDeviceTokenEntity>().eq("device_sn",deviceSn))).filter(list->list!=null&&!list.isEmpty()).map(t->t.get(0)).orElseThrow(()->new BusinessException("device_sn not exist"));
        return Result.ok(hdsDeviceTokenEntity.getToken());
    }
}
