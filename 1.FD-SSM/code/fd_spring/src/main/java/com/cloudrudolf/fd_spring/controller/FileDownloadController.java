package com.cloudrudolf.fd_spring.controller;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.File;

@RestController
public class FileDownloadController {

    @PostMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam String file_name) {
        File file = new File("/home/ubuntu/web_file/" + file_name);

        if (!file.exists()) {
            return ResponseEntity.notFound().build();
        }

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + file.getName());

        Resource resource = new FileSystemResource(file);
        return ResponseEntity.ok().headers(headers).body(resource);
    }
}
