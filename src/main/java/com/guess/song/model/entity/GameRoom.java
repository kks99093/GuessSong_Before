package com.guess.song.model.entity;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import org.hibernate.annotations.CreationTimestamp;

import lombok.Data;

@Data
@Entity
public class GameRoom {
	
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer roomPk;
	
	private String title;
	
	private String password;
	
	private String reader;
	
	private int maximumNum;

	private int boardPk;
	
	@Column
	@CreationTimestamp
	private Timestamp createTime;


}
