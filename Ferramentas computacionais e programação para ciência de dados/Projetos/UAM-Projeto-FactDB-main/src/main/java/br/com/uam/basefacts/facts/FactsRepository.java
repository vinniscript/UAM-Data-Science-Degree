package br.com.uam.basefacts.facts;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface FactsRepository extends JpaRepository<Facts, Long> {

    @Query("SELECT f FROM Facts f WHERE f.userEmail = ?1") // '?1' is a placeholder for the first parameter.
    Optional<Facts> findByEmail(String email); // String email is the parameter that we talked about in the query.
                                                    // How spring boot deals with it, I don't know.
    // Optional is a container object which may or may not contain a non-null value.

}
