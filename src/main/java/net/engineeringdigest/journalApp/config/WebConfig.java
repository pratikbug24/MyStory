package net.engineeringdigest.journalApp.config;

import net.engineeringdigest.journalApp.Service.ProfileImageService;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    private final ProfileImageService profileImageService;

    public WebConfig(ProfileImageService profileImageService) {
        this.profileImageService = profileImageService;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("/resources/");

        // Uploaded photos live outside the jar, so they are mapped to their own
        // URL space. Only the files this service wrote are ever placed here.
        //
        // The trailing slash matters: Path.toUri() only appends one when the
        // directory already exists, and without it Spring treats "photo.png" as a
        // sibling of the upload dir rather than a child, which 404s until the first
        // upload happens to create the directory.
        String uploadLocation = profileImageService.getUploadDir().toUri().toString();
        if (!uploadLocation.endsWith("/")) {
            uploadLocation += "/";
        }
        registry.addResourceHandler("/uploads/**").addResourceLocations(uploadLocation);
    }

    /**
     * The standalone pages in {@code frantend/} call the API from a different
     * origin, so they need credentialed CORS to send the JWT cookie. Origins are
     * listed explicitly because {@code allowCredentials} is incompatible with a "*" origin.
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:8088", "http://localhost:3000", "http://localhost:8080")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}