package com.guess.song.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class RestFile {
	
	private MultipartFile singFile;
	
	private List<MultipartFile> multiFileList;
	
	private List<String> answer;

}
