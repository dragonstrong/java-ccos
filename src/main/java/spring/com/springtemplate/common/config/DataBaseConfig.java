package spring.com.springtemplate.common.config;
import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.config.GlobalConfig;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.InnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.type.DateTypeHandler;
import org.apache.ibatis.type.TypeHandler;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import javax.annotation.Resource;
import javax.sql.DataSource;
/**
 * @Author qiang.long
 * @Date 2024/03/15
 * @Description 数据库配置  :不配置Bean注入失败，比如必须@MapperScan显式声明 mapper的路径，否则找不到
 **/

@Configuration
@MapperScan(basePackages = {"spring.com.springtemplate.mapper"},sqlSessionFactoryRef = "sqlSessionFactory")
public class DataBaseConfig {

    @Resource
    private DataSource dataSource;

    @Bean
    public MybatisPlusInterceptor innerInterceptor(){
        MybatisPlusInterceptor mybatisPlusInterceptor=new MybatisPlusInterceptor();
        mybatisPlusInterceptor.addInnerInterceptor((InnerInterceptor)new PaginationInnerInterceptor(DbType.MYSQL));
        return mybatisPlusInterceptor;
    }


    @Bean
    public MybatisPlusInterceptor paginationInterceptor(){
        MybatisPlusInterceptor mybatisPlusInterceptor=new MybatisPlusInterceptor();
        PaginationInnerInterceptor paginationInnerInterceptor=new PaginationInnerInterceptor();
        paginationInnerInterceptor.setOverflow(false);
        paginationInnerInterceptor.setMaxLimit(Long.valueOf(-1L));
        mybatisPlusInterceptor.addInnerInterceptor((InnerInterceptor)paginationInnerInterceptor);
        return mybatisPlusInterceptor;
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception{
        MybatisSqlSessionFactoryBean sqlSessionFactoryBean=new MybatisSqlSessionFactoryBean();
        sqlSessionFactoryBean.setGlobalConfig(globalConfig());
        sqlSessionFactoryBean.setPlugins(new Interceptor[] {(Interceptor) paginationInterceptor()});
        sqlSessionFactoryBean.setDataSource(this.dataSource);
        sqlSessionFactoryBean.setTypeHandlers(new TypeHandler[] {(TypeHandler) new DateTypeHandler()});
        sqlSessionFactoryBean.setTypeAliasesPackage("spring.com.springtemplate.pojo.entity");  // 配置entity路径
        PathMatchingResourcePatternResolver resolver=new PathMatchingResourcePatternResolver();
        sqlSessionFactoryBean.setMapperLocations(resolver.getResources("classpath:spring/com/springtemplate/mapper/*.xml"));  // 配置mapper .xml文件路径
        return sqlSessionFactoryBean.getObject();
    }

    @Bean
    public GlobalConfig globalConfig(){
        GlobalConfig globalConfig=new GlobalConfig();
        GlobalConfig.DbConfig dbConfig=new GlobalConfig.DbConfig();
        globalConfig.setDbConfig(dbConfig);
        return globalConfig;
    }


}