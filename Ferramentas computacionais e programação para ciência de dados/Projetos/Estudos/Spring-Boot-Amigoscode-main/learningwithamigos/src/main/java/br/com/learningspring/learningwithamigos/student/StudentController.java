package br.com.learningspring.learningwithamigos.student;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.data.jpa.domain.AbstractPersistable_.id;

@RestController
@RequestMapping(path = "ap1/v1/student") // localhost:8080/ap1/v1/student will be the path to access this controller.
                                                // This is a good practice to version the API.
public class StudentController {

    private final StudentService studentService; // This is a bean, it is managed by Spring. It is a dependency.
                                                    // It is a way to inject the dependency into the class.
    @Autowired
    public StudentController(StudentService studentService) { // Constructor
        this.studentService = studentService;
    }


    @GetMapping
    public List<Student> getStudents() {
        return studentService.getStudents();
    }

    // In those lines above, we are creating a controller that will return a list of students.

    // In topics, we did:
    // 1. Created a service that returns a list of students.
    // 2. Created a controller that will return the list of students using the get Method of our service.
    // 3. We used the @RestController annotation to indicate that this class is a controller.
    // 4. We used the @RequestMapping annotation to indicate the path to access this controller.
    // 5. We used the @GetMapping annotation to indicate that this method will be called when a GET request is made to the path.
    // 6. We injected the service into the controller using the constructor.
    // 7. We returned the list of students from the service.

    @PostMapping // This annotation is used to indicate that this method will be called when a POST request is made to the path.
    // a POST is used to send data to the server, in this case, we'll send a student object.
    public void registerNewStudent(@RequestBody Student student) { // @RequestBody means that the student object will be sent in the body of the request.
                                                                     // which means that the student object will be sent in the JSON format by the client.
        studentService.addNewStudent(student);
    }

    @DeleteMapping(path="{studentId}") // This annotation is used to indicate that this method will be called when a DELETE request is made to the path.
                                            // This path is a variable, it will be used to delete a student by id.
    public void deleteStudent(
            @PathVariable("studentId") Long studentId) { // @PathVariable is used to indicate that the studentId will be a variable in the path.
        studentService.deleteStudent(studentId);
    }

    @PutMapping(path = "{studentId}") // This annotation is used to indicate that this method will be called when a PUT request is made to the path.
    // A PUT request is used to update data on the server.
    public void updateStudent(
        @PathVariable("studentId") Long studentId,
        @RequestParam(required = false) String name, // @RequestParam is used to indicate that the name will be a parameter in the request.
        @RequestParam(required = false) String email){ // required = false means that the parameter is not required.
        studentService.updateStudent(studentId, name, email);
    }
}