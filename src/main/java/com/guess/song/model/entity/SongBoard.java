package com.guess.song.model.entity;

import java.sql.Timestamp;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Data;

@Data
@Entity
public class SongBoard {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer boardPk;
	
	private String title;
	
	private String password;
	
	private String salt;
	
	private String img;
	
	@OneToMany(mappedBy = "songBoard")
	private List<SongInfo> songInfoList;

	@Column
	@CreationTimestamp
	private Timestamp createTime;	
	

}
