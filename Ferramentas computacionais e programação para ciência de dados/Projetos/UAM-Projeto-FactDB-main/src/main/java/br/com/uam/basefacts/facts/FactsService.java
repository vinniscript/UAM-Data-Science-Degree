package br.com.uam.basefacts.facts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

@Service
public class FactsService {

    private final FactsRepository factsRepository;

    @Autowired // we need this, for the dependency injection to work. The dependency in this case is the FactsRepository. Which is a dependency of FactsService.
    public FactsService(FactsRepository factsRepository) {
        this.factsRepository = factsRepository;
    }

    public List<Facts> getFacts() {
        return factsRepository.findAll();
    }

    public void addNewFacts(Facts facts) {
        factsRepository.save(facts);

    }

    public void deleteFacts(Long factsId) {
        boolean exists = factsRepository.existsById(factsId); // existsById is a method from the JpaRepository interface.
        if(!exists) {
            throw new IllegalStateException(
                    "facts with id " + factsId + " does not exist"
            );
        }
        factsRepository.deleteById(factsId);
    }


    @Transactional // This annotation is used to indicate that this method will be used to update the facts.
    public void updateFacts(Long factsId, String url, String email) {
        Facts facts = factsRepository.findById(factsId)
            .orElseThrow(() -> new IllegalStateException(
                    "facts with id " + factsId + " does not exist"
            ));
        if(url != null  &&
                !url.isEmpty()) {
            facts.setUrl(url);
        }
        if(email != null &&
                !email.isEmpty()) {
            facts.setUserEmail(email);
        }

    }
}
