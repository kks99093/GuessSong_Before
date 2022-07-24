package com.guess.song.model.entity;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

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
	
	@OneToOne
	private SongBoard songBoard;
	
	@Column
	@CreationTimestamp
	private Timestamp createTime;


}
