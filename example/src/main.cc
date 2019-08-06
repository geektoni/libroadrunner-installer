#include "rrException.h"
#include "rrExecutableModel.h"
#include "rrLogger.h"
#include "rrLogger.h"
#include "rrRoadRunner.h"
#include "rrUtils.h"

void IntegratorInfo(rr::RoadRunner* r) {
  std::cout << "------------------------------------------------------------\n";
  std::cout << "IntegratorInfo\n";
  std::cout << r->getSimulateOptions().toString() << std::endl;
  auto* integrator = r->getIntegrator();
  std::cout << integrator->toString() << std::endl;
  for (auto& setting : integrator->getSettings()) {
    std::cout << std::endl;
    std::cout << setting << std::endl;
    std::cout << integrator->getHint(setting) << std::endl;
    std::cout << integrator->getDescription(setting) << std::endl;
  }
  std::cout
      << "------------------------------------------------------------\n\n";
}

void ModelInfo(rr::RoadRunner* r) {
  std::cout << "------------------------------------------------------------\n";
  std::cout << "ModelInfo\n";
  auto* model = r->getModel();
  std::cout << model->getExecutableModelDesc() << "\n\n";
  std::list<std::string> ids;
  model->getIds(0xffffffff, ids);
  std::cout << "List of all ids in the model\n";
  for (auto& id : ids) {
    std::cout << id << std::endl;
  }
  std::cout
      << "------------------------------------------------------------\n\n";
}

int main(int argc, const char** argv) {
  bool debug = true;

  rr::RoadRunner r("../src/sbml-model.xml");
  r.getSimulateOptions().start=0;
  r.getSimulateOptions().duration=10;
  r.getSimulateOptions().steps=100;
  std::cout << r.getSimulateOptions().toString() << std::endl;
  // setup integrator
  r.setIntegrator("gillespie");
  double dt = r.getSimulateOptions().duration / r.getSimulateOptions().steps;
  auto* integrator = r.getIntegrator();
  integrator->setValue("variable_step_size", false);
  integrator->setValue("initial_time_step", dt);
  integrator->setValue("maximum_time_step", dt);

  if (debug) {
    ModelInfo(&r);
    IntegratorInfo(&r);
  }

  auto* result = r.simulate();

  if (debug) {
    std::cout << *result << std::endl;
    std::cout << r.getValue("S1") << std::endl;
  }

   return 0;
}
