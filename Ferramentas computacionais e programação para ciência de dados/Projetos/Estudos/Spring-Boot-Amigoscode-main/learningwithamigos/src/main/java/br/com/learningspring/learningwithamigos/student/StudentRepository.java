package br.com.learningspring.learningwithamigos.student;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;


// This will be responsible for the data access layer.
@Repository
public interface StudentRepository
        extends JpaRepository<Student, Long > { // JpaRepository works with the entity and the type of the primary key.

    @Query("SELECT s FROM Student s WHERE s.email = ?1")
    Optional<Student> findStudentByEmail(String email); // This is a query method, it will be used to find a student by email.
    // A way to create a query method in Spring Data JPA.

}
