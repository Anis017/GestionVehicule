package fr.nanterre.vehicules;

import java.util.ArrayList;
import java.util.List;

public class GestionVehicule {
    static final String VERSION = "0.2.0";

    public static void main(String[] args) {
        System.out.println("Gestion de véhicules - v" + VERSION);
        List<Vehicule> parc = new ArrayList<>();
        AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Renault", "Clio", 2021));
        AjoutVehicule.ajouter(parc, new Vehicule("EF-456-GH", "Peugeot", "208", 2019));
        AjoutVehicule.ajouter(parc, new Vehicule("IJ-789-KL", "Tesla", "Model 3", 2023));

        System.out.println("Ajout d'un doublon : "
                + AjoutVehicule.ajouter(parc, new Vehicule("AB-123-CD", "Dacia", "Sandero", 2020)));

        afficher(parc);
    }

    static void afficher(List<Vehicule> parc) {
        System.out.println(parc.size() + " véhicules dans le parc :");
        for (Vehicule v : parc) {
            System.out.println("  " + v);
        }
    }
}
