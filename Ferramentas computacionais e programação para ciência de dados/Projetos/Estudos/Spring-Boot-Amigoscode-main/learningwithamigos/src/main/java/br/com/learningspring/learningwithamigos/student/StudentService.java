package br.com.learningspring.learningwithamigos.student;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

// @Component // It declares that this class is a Spring bean.
            // A bean is a complex concept, but in a simple way, it is a class that is managed by Spring.
             // Being magaged by Spring means that Spring will create an instance of this class and will keep it in a container.
              // Which means that we can inject this class into other classes. This is called dependency injection.
                // Just like an object in a class, but it were created by Spring before.

@Service // This annotation is used to indicate that this class is a service, which means that it will have business logic.
            // @Service is a specialization of @Component, it will be served to other classes, like the Controller class.

public class StudentService { // Now, with the notion of a service, we've declared this class as a service.

    private final StudentRepository studentRepository;

    @Autowired
    public StudentService(StudentRepository studentRepository) {
        this.studentRepository = studentRepository;
    }

    public List<Student> getStudents() { // Bringing a list of Students defined in other package/class.
        return studentRepository.findAll(); // This is the magic of Spring Data JPA, we don't need to implement the method, it is already implemented.

        /*
        *  We could use something like this to create a list of students:
                        *
        return List.of(
                new Student(
                        1L,
                        "Mariam",
                        "maria.email@examples.com",
                        LocalDate.of(2000, Month.JANUARY, 5),
                        21),
                 new Student(
                        2L,
                        "Carl",
                        "carl.email@examples.com",
                        LocalDate.of(1999, Month.MARCH, 1),
                        22));
                        ...
                        *

           But instead, we are using the findAll() method from the JpaRepository interface. It covers the basic CRUD operations.

        * */
    }

    public void addNewStudent(Student student) {
        Optional<Student> studentOptional = studentRepository // Optional is a container object that may or may not contain a non-null value.
                .findStudentByEmail(student.getEmail()); // We are using the query method that we have created in the repository.
        if(studentOptional.isPresent()) { // If the student is present in the database,
            throw new IllegalStateException("email taken"); // we throw an exception.
        }
        studentRepository.save(student); // If the student is not present, we save it.
    }

    public void deleteStudent(Long studentId) {
        boolean exists = studentRepository.existsById(studentId);
        if (!exists){
            throw new IllegalStateException("Student with id " + studentId + "does not exists.");
        }
        studentRepository.deleteById(studentId);
    }

    @Transactional // This annotation is used to indicate that this method will be used to update the student.
                        // It is a way to manage the transaction, which means that if the method fails, it will rollback the transaction.
    public void updateStudent(Long studentId,
                              String name,
                              String email) {

        Student student = studentRepository.findById(studentId)
                .orElseThrow(() -> new IllegalStateException(
                        "Student with id" + studentId + "does not exists"));

        if (name != null && // If name is not null,
                !name.isEmpty() && // not empty and
                !Objects.equals(student.getName(), name)){ // is different from the name in the database,
            student.setName(name); //  we update it.
        }

        if (email != null && // If email is not null,
                !email.isEmpty() && // not empty and
                !Objects.equals(student.getEmail(), email)){ // is different from the email in the database, we check if it is different.
            Optional<Student> studentOptional = studentRepository // Optional = have or not have a value.
                    .findStudentByEmail(email); // With the email passed, we check if it is already in the database.
            if (studentOptional.isPresent()){ // if the email is present,
                throw new IllegalStateException("email taken"); // we throw an exception.
            }
            student.setEmail(email); //  we update it.
        }

    }
}
