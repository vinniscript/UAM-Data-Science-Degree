package br.com.uam.basefacts.facts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path="ap1/v1/facts")

public class FactsController {

    private final FactsService factsService;

    @Autowired
    public FactsController(FactsService factsService) {
        this.factsService = factsService;
    }

    @GetMapping
    public List<Facts> getFacts() {
        return factsService.getFacts();
    }

    @PostMapping
    public void SubmitFacts(@RequestBody Facts facts){
        factsService.addNewFacts(facts);
    }

    @DeleteMapping(path="{factsId}")
    public void deleteFacts(
            @PathVariable("factsId") Long factsId) {
        factsService.deleteFacts(factsId);
    }

    @PutMapping(path = "{factsId}")
    public void updateFacts(
            @PathVariable("factsId") Long factsId,
            @RequestParam(required = false) String url, // Precisa ser exatamente igual ao nome do atributo da classe.
            @RequestParam(required = false) String userEmail){ // Precisa ser exatamente igual ao nome do atributo da classe.
        factsService.updateFacts(factsId, url, userEmail);
    }

}
