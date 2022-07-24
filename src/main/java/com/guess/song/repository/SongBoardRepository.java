package com.guess.song.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.guess.song.model.entity.SongBoard;

@Repository
public interface SongBoardRepository extends JpaRepository<SongBoard, Integer>{
	
	SongBoard findByBoardPk(int boardPk);

}
